import SwiftUI

struct ChecklistItemRow: View {
    let item: ChecklistItem
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(item.isChecked ? Color.green : Color.red)
                Text(item.name)
                    .foregroundStyle(item.isChecked ? Color.primary : Color.red)
                Spacer(minLength: 8)
                Label(item.barcode, systemImage: "barcode")
                    .font(.footnote.monospaced())
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(item.name)
        .accessibilityValue(item.isChecked ? "Cargado" : "Falta")
        .accessibilityHint("Código \(item.barcode)")
    }
}

#Preview {
    List {
        ChecklistItemRow(item: ChecklistItem(name: "Cono", barcode: "CYA-01", isChecked: true), onToggle: {})
        ChecklistItemRow(item: ChecklistItem(name: "Placa base", barcode: "CYA-02"), onToggle: {})
    }
}
