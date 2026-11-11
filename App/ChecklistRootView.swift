import SwiftUI

struct ChecklistRootView: View {
    @State private var checklistViewModel = ChecklistViewModel(
        catalog: LocalTestCatalogRepository(),
        finalizeUseCase: FinalizeChecklistUseCase(
            renderer: PDFChecklistRenderer(),
            storage: DocumentsReportStorage()
        ),
        haptics: ImpactHapticFeedbackProvider()
    )

    var body: some View {
        ChecklistView(viewModel: checklistViewModel)
    }
}
