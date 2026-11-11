import Foundation

@MainActor
protocol FinalizeChecklistUseCaseProtocol {
    /// Valida el borrador, genera el PDF y lo guarda.
    /// - Returns: Ubicación del PDF generado.
    /// - Throws: `ChecklistError`.
    func execute(_ draft: ChecklistDraft) async throws -> URL
}

@MainActor
struct FinalizeChecklistUseCase: FinalizeChecklistUseCaseProtocol {
    private let renderer: any ChecklistReportRendering
    private let storage: any ReportStorageProtocol

    init(renderer: any ChecklistReportRendering, storage: any ReportStorageProtocol) {
        self.renderer = renderer
        self.storage = storage
    }

    func execute(_ draft: ChecklistDraft) async throws -> URL {
        let checklist = try Self.validate(draft)
        let pdf = try renderer.render(checklist)
        return try await storage.save(pdf, fileName: Self.fileName(for: checklist))
    }

    static func validate(_ draft: ChecklistDraft) throws -> Checklist {
        let header = draft.header.sanitized()
        guard !header.project.isEmpty else { throw ChecklistError.missingProject }
        guard !header.preparedBy.isEmpty else { throw ChecklistError.missingPreparedBy }

        let sections = draft.sections.filter { !$0.items.isEmpty }
        guard !sections.isEmpty else { throw ChecklistError.noTestsSelected }

        guard let signature = draft.signaturePNG, !signature.isEmpty else {
            throw ChecklistError.missingSignature
        }

        return Checklist(
            movement: draft.movement,
            date: draft.date,
            header: header,
            sections: sections,
            signaturePNG: signature
        )
    }

    static func fileName(for checklist: Checklist) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd_HHmm"

        let parts = [
            "Checklist",
            checklist.movement.displayName,
            checklist.header.project.fileNameComponent(),
            formatter.string(from: checklist.date)
        ]
        return parts.filter { !$0.isEmpty }.joined(separator: "_") + ".pdf"
    }
}
