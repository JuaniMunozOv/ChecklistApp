import Foundation

struct LocalTestCatalogRepository: TestCatalogRepositoryProtocol {
    func fetchSection(for testType: TestType) async throws -> ChecklistSection {
        guard let entries = TestCatalog.entries[testType], !entries.isEmpty else {
            throw ChecklistError.catalogUnavailable
        }
        let items = entries.map { ChecklistItem(name: $0.name, barcode: $0.barcode) }
        return ChecklistSection(testType: testType, items: items)
    }
}
