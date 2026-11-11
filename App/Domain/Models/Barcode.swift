import Foundation

/// Código de barras validado: mayúsculas, números y guiones, entre 3 y 32 caracteres.
struct Barcode: Hashable, Sendable {
    static let allowedLength = 3...32
    private static let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")

    let value: String

    /// - Returns: `nil` si el texto leído no cumple el formato.
    init?(_ raw: String) {
        let normalized = raw.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard Self.allowedLength.contains(normalized.count),
              normalized.unicodeScalars.allSatisfy({ Self.allowedCharacters.contains($0) }) else {
            return nil
        }
        value = normalized
    }
}
