import SwiftUI

struct TestItemsSection: View {
    let section: ChecklistSection
    let onToggle: (UUID) -> Void

    var body: some View {
        Section {
            ForEach(section.items) { item in
                ChecklistItemRow(item: item) { onToggle(item.id) }
            }
        } header: {
            HStack {
                Text(section.title)
                Spacer()
                Text(section.checkedCount == section.items.count
                     ? "Completo"
                     : "Faltan \(section.items.count - section.checkedCount)")
                    .monospacedDigit()
                    .foregroundStyle(section.checkedCount == section.items.count ? Color.secondary : Color.red)
            }
        }
    }
}
