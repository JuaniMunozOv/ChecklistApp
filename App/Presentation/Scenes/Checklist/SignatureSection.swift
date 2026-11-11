import SwiftUI

struct SignatureSection: View {
    let signaturePNG: Data?
    let onSign: () -> Void

    var body: some View {
        Section("Firma de quien elabora") {
            if let signaturePNG, let image = UIImage(data: signaturePNG) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .padding(8)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 8))
                    .accessibilityLabel("Firma registrada")
                Button("Volver a firmar", action: onSign)
            } else {
                Button(action: onSign) {
                    Label("Firmar", systemImage: "signature")
                }
            }
        }
    }
}
