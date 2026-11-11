import Foundation

enum HapticFeedback: Sendable {
    case success
    case warning
    case error
}

@MainActor
protocol HapticFeedbackProviding {
    func play(_ feedback: HapticFeedback)
}
