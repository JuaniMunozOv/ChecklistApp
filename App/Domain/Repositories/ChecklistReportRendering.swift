import Foundation

@MainActor
protocol ChecklistReportRendering {
    /// Devuelve el contenido del PDF.
    /// - Throws: `ChecklistError.reportGenerationFailed`.
    func render(_ checklist: Checklist) throws -> Data
}
