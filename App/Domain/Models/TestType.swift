import Foundation

enum TestType: String, CaseIterable, Identifiable, Sendable {
    case sandCone
    case plateLoad
    case dcp
    case cbr
    case proctorT99
    case proctorT180
    case granulometry
    case atterbergLimits
    case laboratory

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .sandCone: "Cono y Arena"
        case .plateLoad: "Placa de Carga"
        case .dcp: "DCP"
        case .cbr: "CBR"
        case .proctorT99: "Proctor T99"
        case .proctorT180: "Proctor T180"
        case .granulometry: "Granulometría"
        case .atterbergLimits: "Límites de Atterberg"
        case .laboratory: "Elementos de Laboratorio"
        }
    }

    var sortOrder: Int {
        Self.allCases.firstIndex(of: self) ?? Self.allCases.count
    }
}
