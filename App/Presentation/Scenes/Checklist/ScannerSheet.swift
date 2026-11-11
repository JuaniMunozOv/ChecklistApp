import SwiftUI

struct ScannerSheet: View {
    let viewModel: ChecklistViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var availability = CameraAvailability.checking

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom) {
                    VStack(spacing: 0) {
                        BarcodeWedgeField(
                            isActive: true,
                            knownCodes: viewModel.knownBarcodes,
                            placeholder: "Lector externo",
                            onScan: { viewModel.handleScannedCode($0) }
                        )
                        .padding(.horizontal)
                        .padding(.top, 8)
                        ScanFeedbackBanner(
                            feedback: viewModel.lastScanFeedback,
                            checkedCount: viewModel.checkedCount,
                            totalCount: viewModel.totalCount
                        )
                    }
                }
                .navigationTitle("Escanear elementos")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Listo") { dismiss() }
                    }
                }
        }
        .task { availability = await CameraAvailability.resolve() }
    }

    @ViewBuilder
    private var content: some View {
        switch availability {
        case .checking:
            ProgressView("Preparando cámara…")
        case .available:
            BarcodeScannerView(
                onScan: { viewModel.handleScannedCode($0) },
                onUnavailable: { availability = .denied }
            )
            .ignoresSafeArea(edges: .horizontal)
        case .unsupported:
            ContentUnavailableView(
                "Escáner no disponible",
                systemImage: "barcode.viewfinder",
                description: Text("Este dispositivo no permite escanear códigos. Marcá los elementos tocándolos en la lista.")
            )
        case .denied:
            CameraDeniedView()
        }
    }
}

private struct CameraDeniedView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Sin acceso a la cámara", systemImage: "camera.fill")
        } description: {
            Text("Permití el uso de la cámara en Ajustes para escanear los códigos de los elementos.")
        } actions: {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                Link("Abrir Ajustes", destination: settingsURL)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}
