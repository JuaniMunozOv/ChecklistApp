import Foundation

struct FinalizedReport: Identifiable, Equatable, Sendable {
    let url: URL
    let movement: MovementType

    var id: URL { url }
}
