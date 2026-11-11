import Foundation

enum MovementType: String, CaseIterable, Identifiable, Sendable {
    case outbound
    case inbound

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .outbound: "Salida"
        case .inbound: "Regreso"
        }
    }
}
