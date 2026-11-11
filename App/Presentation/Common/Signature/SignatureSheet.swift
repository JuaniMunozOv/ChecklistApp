import PencilKit
import SwiftUI

struct SignatureSheet: View {
    let signerName: String
    let onSave: (Data?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var drawing = PKDrawing()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                SignatureCanvas(drawing: $drawing)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.separator))
                Text(signerName.isEmpty ? "Firmá dentro del recuadro" : "Firma de \(signerName)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("Firma")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        onSave(SignatureImageExporter.pngData(from: drawing))
                        dismiss()
                    }
                    .disabled(drawing.strokes.isEmpty)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Borrar", role: .destructive) { drawing = PKDrawing() }
                        .disabled(drawing.strokes.isEmpty)
                }
            }
        }
    }
}

#Preview {
    SignatureSheet(signerName: "Juan Pérez") { _ in }
}
