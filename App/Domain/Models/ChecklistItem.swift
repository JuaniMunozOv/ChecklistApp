import Foundation

/// Elemento físico del checklist: va siempre una sola unidad, identificada por su código de barras.
struct ChecklistItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let barcode: String
    let isChecked: Bool

    init(id: UUID = UUID(), name: String, barcode: String, isChecked: Bool = false) {
        self.id = id
        self.name = name
        self.barcode = barcode
        self.isChecked = isChecked
    }

    func with(isChecked: Bool) -> ChecklistItem {
        ChecklistItem(id: id, name: name, barcode: barcode, isChecked: isChecked)
    }

    func toggled() -> ChecklistItem {
        with(isChecked: !isChecked)
    }
}
