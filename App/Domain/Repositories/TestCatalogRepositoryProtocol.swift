import Foundation

protocol TestCatalogRepositoryProtocol: Sendable {
    /// - Throws: `ChecklistError.catalogUnavailable` si el ensayo no tiene elementos definidos.
    func fetchSection(for testType: TestType) async throws -> ChecklistSection
}
