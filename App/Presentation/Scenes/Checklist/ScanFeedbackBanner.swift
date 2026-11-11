import SwiftUI

struct ScanFeedbackBanner: View {
    let feedback: ScanFeedback?
    let checkedCount: Int
    let totalCount: Int

    var body: some View {
        VStack(spacing: 10) {
            if let feedback {
                Label(feedback.message, systemImage: symbol(for: feedback))
                    .font(.headline)
                    .foregroundStyle(tint(for: feedback))
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            } else {
                Text("Apuntá la cámara al código de un elemento")
                    .font(.headline)
            }
            ProgressView(value: Double(checkedCount), total: Double(max(totalCount, 1)))
            Text("\(checkedCount) de \(totalCount) elementos controlados")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .animation(.default, value: feedback)
        .accessibilityElement(children: .combine)
    }

    private func symbol(for feedback: ScanFeedback) -> String {
        switch feedback {
        case .marked: "checkmark.circle.fill"
        case .alreadyMarked: "checkmark.circle"
        case .notInChecklist: "xmark.octagon.fill"
        case .invalidCode: "exclamationmark.triangle.fill"
        }
    }

    private func tint(for feedback: ScanFeedback) -> Color {
        switch feedback {
        case .marked: .green
        case .alreadyMarked: .orange
        case .notInChecklist, .invalidCode: .red
        }
    }
}

#Preview {
    ScanFeedbackBanner(feedback: .marked(itemName: "Pesas", testName: "CBR"), checkedCount: 3, totalCount: 9)
}
