import SwiftUI

struct FinalizedReportView: View {
    let report: FinalizedReport
    let onStartReturn: () -> Void
    let onStartNew: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Checklist de \(report.movement.displayName.lowercased()) generado", systemImage: "checkmark.seal.fill")
        } description: {
            Text(report.url.lastPathComponent)
                .font(.callout.monospaced())
            Text("Guardado en Archivos › En mi iPad › Checklist › Checklists")
        } actions: {
            ShareLink(item: report.url) {
                Label("Enviar o compartir PDF", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)

            if report.movement == .outbound {
                Button("Preparar checklist de regreso", action: onStartReturn)
                    .buttonStyle(.bordered)
            }
            Button("Nuevo checklist", action: onStartNew)
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    FinalizedReportView(
        report: FinalizedReport(url: URL(filePath: "/tmp/Checklist_Salida_Ruta-40_2026-11-10_0930.pdf"), movement: .outbound),
        onStartReturn: {},
        onStartNew: {}
    )
}
