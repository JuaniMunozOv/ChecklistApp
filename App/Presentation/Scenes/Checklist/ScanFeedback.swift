import Foundation

enum ScanFeedback: Equatable, Sendable {
    case marked(itemName: String, testName: String)
    case alreadyMarked(itemName: String)
    case notInChecklist(code: String)
    case invalidCode

    var message: String {
        switch self {
        case .marked(let itemName, let testName): "\(itemName) · \(testName)"
        case .alreadyMarked(let itemName): "\(itemName) ya estaba controlado"
        case .notInChecklist(let code): "El código \(code) no pertenece a los ensayos elegidos"
        case .invalidCode: "Código no reconocido"
        }
    }
}
