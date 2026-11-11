import SwiftUI

struct FinalizeSection: View {
    let isFinalizing: Bool
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Section {
            Button(action: action) {
                HStack {
                    Spacer()
                    if isFinalizing {
                        ProgressView()
                    } else {
                        Label("Finalizar y generar PDF", systemImage: "doc.richtext")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
            }
            .disabled(!isEnabled || isFinalizing)
        } footer: {
            Text("El PDF se guarda con la fecha en Archivos › En mi iPad › Checklist › Checklists.")
        }
    }
}
