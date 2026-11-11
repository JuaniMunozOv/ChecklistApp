import SwiftUI

struct ChecklistView: View {
    @Bindable var viewModel: ChecklistViewModel
    @State private var isSigning = false
    @State private var isScanning = false

    var body: some View {
        NavigationStack {
            Form {
                HeaderFormSection(viewModel: viewModel)
                TestSelectionSection(selectedTests: viewModel.selectedTests) { testType in
                    Task { await viewModel.toggle(testType) }
                }
                ForEach(viewModel.sections) { section in
                    TestItemsSection(section: section) { viewModel.toggleCheck(itemID: $0) }
                }
                SignatureSection(signaturePNG: viewModel.signaturePNG) { isSigning = true }
                FinalizeSection(isFinalizing: viewModel.isFinalizing, isEnabled: viewModel.hasSelectedTests) {
                    Task { await viewModel.finalize() }
                }
            }
            .navigationTitle("Check-list de ensayos")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.beginScanning()
                        isScanning = true
                    } label: {
                        Label("Escanear", systemImage: "barcode.viewfinder")
                            .labelStyle(.titleAndIcon)
                    }
                    .disabled(!viewModel.hasSelectedTests)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if viewModel.hasSelectedTests {
                    BarcodeWedgeField(
                        isActive: false,
                        knownCodes: viewModel.knownBarcodes,
                        placeholder: "Lector externo: tocá acá y dispará",
                        onScan: { viewModel.handleScannedCode($0) }
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.bar)
                }
            }
            .fullScreenCover(isPresented: $isScanning, onDismiss: { viewModel.finishScanning() }) {
                ScannerSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $isSigning) {
                SignatureSheet(signerName: viewModel.preparedBy) { viewModel.setSignature($0) }
            }
            .sheet(item: $viewModel.finalizedReport) { report in
                FinalizedReportView(
                    report: report,
                    onStartReturn: { viewModel.startReturnChecklist() },
                    onStartNew: { viewModel.startNew() }
                )
            }
            .alert("No se pudo completar", isPresented: isShowingError) {
                Button("Aceptar", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var isShowingError: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

#Preview {
    ChecklistView(
        viewModel: ChecklistViewModel(
            catalog: LocalTestCatalogRepository(),
            finalizeUseCase: FinalizeChecklistUseCase(
                renderer: PDFChecklistRenderer(),
                storage: DocumentsReportStorage()
            ),
            haptics: SilentHapticFeedbackProvider()
        )
    )
}
