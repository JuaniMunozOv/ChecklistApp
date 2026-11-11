import Foundation
import Observation

@MainActor
@Observable
final class ChecklistViewModel {
    var movement: MovementType = .outbound
    var project = ""
    var destination = ""
    var preparedBy = ""
    var companions = ""
    var errorMessage: String?
    var finalizedReport: FinalizedReport?
    private(set) var sections: [ChecklistSection] = []
    private(set) var signaturePNG: Data?
    private(set) var isFinalizing = false
    private(set) var lastScanFeedback: ScanFeedback?

    @ObservationIgnored private var lastScan: (code: String, date: Date)?
    private static let repeatedScanInterval: TimeInterval = 2

    private let catalog: any TestCatalogRepositoryProtocol
    private let finalizeUseCase: any FinalizeChecklistUseCaseProtocol
    private let haptics: any HapticFeedbackProviding
    private let now: @Sendable () -> Date

    init(
        catalog: any TestCatalogRepositoryProtocol,
        finalizeUseCase: any FinalizeChecklistUseCaseProtocol,
        haptics: any HapticFeedbackProviding,
        now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.catalog = catalog
        self.finalizeUseCase = finalizeUseCase
        self.haptics = haptics
        self.now = now
    }

    var date: Date { now() }

    var selectedTests: Set<TestType> {
        Set(sections.map(\.testType))
    }

    var hasSelectedTests: Bool {
        !sections.isEmpty
    }

    var checkedCount: Int {
        sections.reduce(0) { $0 + $1.checkedCount }
    }

    var totalCount: Int {
        sections.reduce(0) { $0 + $1.items.count }
    }

    var missingCount: Int {
        totalCount - checkedCount
    }

    var knownBarcodes: Set<String> {
        Set(sections.flatMap { $0.items.map(\.barcode) })
    }

    func toggle(_ testType: TestType) async {
        if selectedTests.contains(testType) {
            sections.removeAll { $0.testType == testType }
            return
        }
        do {
            let section = try await catalog.fetchSection(for: testType)
            guard !selectedTests.contains(testType) else { return }
            sections = (sections + [section]).sorted { $0.testType.sortOrder < $1.testType.sortOrder }
        } catch {
            present(error)
        }
    }

    func toggleCheck(itemID: UUID) {
        sections = sections.map { $0.updatingItem(id: itemID) { $0.toggled() } }
    }

    func beginScanning() {
        lastScanFeedback = nil
        lastScan = nil
    }

    /// Al cerrar el escáner, avisa si quedó algo sin leer. Lo faltante sigue en rojo en la lista.
    func finishScanning() {
        guard totalCount > 0 else { return }
        haptics.play(missingCount == 0 ? .success : .warning)
    }

    /// Marca como cargado el elemento cuyo código coincide con la lectura. Nunca desmarca.
    func handleScannedCode(_ rawValue: String) {
        let key = rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanDate = now()
        if let lastScan, lastScan.code == key, scanDate.timeIntervalSince(lastScan.date) < Self.repeatedScanInterval {
            return
        }
        lastScan = (key, scanDate)

        guard let barcode = Barcode(rawValue) else {
            return report(.invalidCode, haptic: .error)
        }
        guard let section = sections.first(where: { $0.item(with: barcode) != nil }),
              let item = section.item(with: barcode) else {
            return report(.notInChecklist(code: barcode.value), haptic: .error)
        }
        guard !item.isChecked else {
            return report(.alreadyMarked(itemName: item.name), haptic: .warning)
        }
        sections = sections.map { $0.updatingItem(id: item.id) { $0.with(isChecked: true) } }
        report(.marked(itemName: item.name, testName: section.title), haptic: .success)
    }

    func setSignature(_ png: Data?) {
        signaturePNG = png
    }

    func finalize() async {
        guard !isFinalizing else { return }
        isFinalizing = true
        defer { isFinalizing = false }

        do {
            let url = try await finalizeUseCase.execute(makeDraft())
            finalizedReport = FinalizedReport(url: url, movement: movement)
            haptics.play(.success)
        } catch {
            present(error)
        }
    }

    /// Prepara el checklist de regreso con el mismo encabezado y ensayos, sin controlar.
    func startReturnChecklist() {
        movement = .inbound
        sections = sections.map { $0.resettingChecks() }
        signaturePNG = nil
        finalizedReport = nil
    }

    func startNew() {
        movement = .outbound
        project = ""
        destination = ""
        companions = ""
        sections = []
        signaturePNG = nil
        finalizedReport = nil
    }

    private func makeDraft() -> ChecklistDraft {
        ChecklistDraft(
            movement: movement,
            date: now(),
            header: ChecklistHeader(project: project, destination: destination, preparedBy: preparedBy, companions: companions),
            sections: sections,
            signaturePNG: signaturePNG
        )
    }

    private func report(_ feedback: ScanFeedback, haptic: HapticFeedback) {
        lastScanFeedback = feedback
        haptics.play(haptic)
    }

    private func present(_ error: any Error) {
        errorMessage = Self.message(for: error)
        haptics.play(.error)
    }

    private static func message(for error: any Error) -> String {
        switch error as? ChecklistError {
        case .catalogUnavailable: "No se encontraron los elementos de este ensayo."
        case .missingProject: "Completá el nombre del proyecto."
        case .missingPreparedBy: "Completá quién elabora el checklist."
        case .noTestsSelected: "Elegí al menos un ensayo."
        case .missingSignature: "Falta la firma de quien elabora el checklist."
        case .reportGenerationFailed: "No se pudo generar el PDF."
        case .storageFailed: "No se pudo guardar el PDF en el iPad."
        case nil: "Ocurrió un error inesperado. Intentá nuevamente."
        }
    }
}
