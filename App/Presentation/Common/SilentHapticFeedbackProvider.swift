import Foundation

@MainActor
struct SilentHapticFeedbackProvider: HapticFeedbackProviding {
    func play(_ feedback: HapticFeedback) {}
}
