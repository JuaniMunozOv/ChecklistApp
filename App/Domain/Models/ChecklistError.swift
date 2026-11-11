import Foundation

enum ChecklistError: Error, Equatable, Sendable {
    case catalogUnavailable
    case missingProject
    case missingPreparedBy
    case noTestsSelected
    case missingSignature
    case reportGenerationFailed
    case storageFailed
}
