import Foundation

protocol ReportStorageProtocol: Sendable {
    /// Guarda el reporte y devuelve su ubicación final. Nunca sobrescribe un archivo existente.
    /// - Throws: `ChecklistError.storageFailed`.
    func save(_ data: Data, fileName: String) async throws -> URL
}
