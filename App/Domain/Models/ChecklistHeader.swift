import Foundation

struct ChecklistHeader: Hashable, Sendable {
    let project: String
    let destination: String
    let preparedBy: String
    let companions: String

    func sanitized() -> ChecklistHeader {
        ChecklistHeader(
            project: project.sanitized(),
            destination: destination.sanitized(),
            preparedBy: preparedBy.sanitized(),
            companions: companions.sanitized()
        )
    }
}
