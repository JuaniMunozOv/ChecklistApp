import SwiftUI

struct TestSelectionSection: View {
    let selectedTests: Set<TestType>
    let onToggle: (TestType) -> Void

    private let columns = [GridItem(.adaptive(minimum: 200), spacing: 10)]

    var body: some View {
        Section {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(TestType.allCases) { testType in
                    TestChip(title: testType.displayName, isSelected: selectedTests.contains(testType)) {
                        onToggle(testType)
                    }
                }
            }
            .padding(.vertical, 6)
        } header: {
            Text("Ensayos")
        } footer: {
            Text("Elegí uno o más ensayos para ver los elementos que hay que cargar.")
        }
    }
}

private struct TestChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: isSelected ? "checkmark.circle.fill" : "circle")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    isSelected ? Color.accentColor.opacity(0.15) : Color(.tertiarySystemFill),
                    in: RoundedRectangle(cornerRadius: 10)
                )
                .contentShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    Form {
        TestSelectionSection(selectedTests: [.cbr, .dcp]) { _ in }
    }
}
