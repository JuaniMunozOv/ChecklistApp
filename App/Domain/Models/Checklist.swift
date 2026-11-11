import Foundation

/// Checklist en edición: todavía puede tener datos incompletos.
struct ChecklistDraft: Sendable {
    let movement: MovementType
    let date: Date
    let header: ChecklistHeader
    let sections: [ChecklistSection]
    let signaturePNG: Data?
}

/// Checklist validado y listo para generar el reporte.
struct Checklist: Sendable {
    let movement: MovementType
    let date: Date
    let header: ChecklistHeader
    let sections: [ChecklistSection]
    let signaturePNG: Data

    var allItems: [ChecklistItem] {
        sections.flatMap(\.items)
    }
}
