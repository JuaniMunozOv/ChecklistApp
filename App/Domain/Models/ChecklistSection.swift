import Foundation

struct ChecklistSection: Identifiable, Hashable, Sendable {
    let testType: TestType
    let items: [ChecklistItem]

    var id: TestType { testType }

    var title: String { testType.displayName }

    var checkedCount: Int {
        items.filter(\.isChecked).count
    }

    func item(with barcode: Barcode) -> ChecklistItem? {
        items.first { $0.barcode == barcode.value }
    }

    func updatingItem(id: UUID, _ transform: (ChecklistItem) -> ChecklistItem) -> ChecklistSection {
        ChecklistSection(testType: testType, items: items.map { $0.id == id ? transform($0) : $0 })
    }

    func resettingChecks() -> ChecklistSection {
        ChecklistSection(testType: testType, items: items.map { $0.with(isChecked: false) })
    }
}
