import SwiftUI
import UIKit

/// Captura lo que escribe un lector externo: esos lectores se comportan como un teclado
/// y terminan el código con Enter, Tab, o con un código que ya existe en el checklist.
struct BarcodeWedgeField: UIViewRepresentable {
    var isActive: Bool
    var knownCodes: Set<String>
    var placeholder: String
    var onScan: (String) -> Void

    func makeUIView(context: Context) -> WedgeTextField {
        let field = WedgeTextField()
        field.delegate = context.coordinator
        field.placeholder = placeholder
        field.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
        field.autocorrectionType = .no
        field.autocapitalizationType = .allCharacters
        field.spellCheckingType = .no
        field.smartQuotesType = .no
        field.smartDashesType = .no
        field.returnKeyType = .done
        field.inputView = UIView()
        field.accessibilityLabel = "Lector de códigos externo"
        return field
    }

    func updateUIView(_ field: WedgeTextField, context: Context) {
        context.coordinator.onScan = onScan
        context.coordinator.knownCodes = knownCodes
        field.placeholder = placeholder
        field.wantsFocus = isActive
        guard isActive, field.window != nil, !field.isFirstResponder else { return }
        field.becomeFirstResponder()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan, knownCodes: knownCodes)
    }

    @MainActor
    final class Coordinator: NSObject, UITextFieldDelegate {
        var onScan: (String) -> Void
        var knownCodes: Set<String>

        init(onScan: @escaping (String) -> Void, knownCodes: Set<String>) {
            self.onScan = onScan
            self.knownCodes = knownCodes
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let current = textField.text ?? ""
            let updated = (current as NSString).replacingCharacters(in: range, with: string)
            let terminated = string.contains { $0 == "\n" || $0 == "\r" || $0 == "\t" }
            let code = updated.filter { $0 != "\n" && $0 != "\r" && $0 != "\t" }
            let matchesKnownCode = knownCodes.contains(code.trimmingCharacters(in: .whitespaces).uppercased())
            guard terminated || matchesKnownCode else { return true }
            textField.text = ""
            if !code.trimmingCharacters(in: .whitespaces).isEmpty {
                onScan(code)
            }
            return false
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            let code = textField.text ?? ""
            textField.text = ""
            if !code.trimmingCharacters(in: .whitespaces).isEmpty {
                onScan(code)
            }
            return false
        }
    }
}

final class WedgeTextField: UITextField {
    var wantsFocus = false

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard wantsFocus, window != nil else { return }
        becomeFirstResponder()
    }
}
