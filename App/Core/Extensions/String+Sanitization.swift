import Foundation

extension String {
    /// Elimina caracteres de control, colapsa espacios y limita el largo.
    func sanitized(maxLength: Int = 120) -> String {
        let printable = unicodeScalars.filter { !CharacterSet.controlCharacters.contains($0) }
        let collapsed = String(String.UnicodeScalarView(printable))
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
        return String(collapsed.prefix(maxLength))
    }

    /// Versión apta para nombres de archivo: sin acentos, sin espacios ni símbolos.
    func fileNameComponent(maxLength: Int = 40) -> String {
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let folded = sanitized(maxLength: maxLength)
            .folding(options: .diacriticInsensitive, locale: Locale(identifier: "es"))
        let mapped = folded.unicodeScalars.map { allowed.contains($0) ? Character($0) : "-" }
        return String(mapped)
            .split(separator: "-")
            .joined(separator: "-")
    }
}
