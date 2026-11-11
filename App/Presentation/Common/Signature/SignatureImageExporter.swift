import PencilKit
import UIKit

enum SignatureImageExporter {
    /// - Returns: PNG con tinta negra sobre fondo transparente, o `nil` si no hay trazos.
    @MainActor
    static func pngData(from drawing: PKDrawing) -> Data? {
        guard !drawing.strokes.isEmpty else { return nil }
        let bounds = drawing.bounds.insetBy(dx: -12, dy: -12)
        var image = UIImage()
        // Con el modo oscuro activo, PencilKit invierte la tinta negra a blanca al exportar.
        UITraitCollection(userInterfaceStyle: .light).performAsCurrent {
            image = drawing.image(from: bounds, scale: 2)
        }
        return image.pngData()
    }
}
