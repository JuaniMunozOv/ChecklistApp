import UIKit

@MainActor
final class ImpactHapticFeedbackProvider: HapticFeedbackProviding {
    func play(_ feedback: HapticFeedback) {
        let generator = UIImpactFeedbackGenerator(style: style(for: feedback))
        generator.prepare()
        generator.impactOccurred()
    }

    private func style(for feedback: HapticFeedback) -> UIImpactFeedbackGenerator.FeedbackStyle {
        switch feedback {
        case .success: .light
        case .warning: .medium
        case .error: .heavy
        }
    }
}
