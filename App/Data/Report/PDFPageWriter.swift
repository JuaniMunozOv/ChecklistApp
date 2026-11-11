import UIKit

@MainActor
struct PDFTextStyle {
    let font: UIFont
    let color: UIColor
    let alignment: NSTextAlignment

    static let body = PDFTextStyle(font: .systemFont(ofSize: 9), color: .black, alignment: .left)
    static let bodyCentered = PDFTextStyle(font: .systemFont(ofSize: 9), color: .black, alignment: .center)
    static let missing = PDFTextStyle(font: .systemFont(ofSize: 9), color: .systemRed, alignment: .left)
    static let missingCentered = PDFTextStyle(font: .boldSystemFont(ofSize: 8), color: .systemRed, alignment: .center)
    static let label = PDFTextStyle(font: .boldSystemFont(ofSize: 9), color: .black, alignment: .left)
    static let labelCentered = PDFTextStyle(font: .boldSystemFont(ofSize: 9), color: .black, alignment: .center)
    static let caption = PDFTextStyle(font: .systemFont(ofSize: 8), color: .darkGray, alignment: .center)
    static let title = PDFTextStyle(font: .boldSystemFont(ofSize: 14), color: .black, alignment: .center)

    var attributes: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        paragraph.lineBreakMode = .byTruncatingTail
        return [.font: font, .foregroundColor: color, .paragraphStyle: paragraph]
    }
}

@MainActor
struct PDFCell {
    let text: String
    let width: CGFloat
    let style: PDFTextStyle
}

/// Escribe contenido de arriba hacia abajo y abre una página nueva cuando no hay espacio.
@MainActor
struct PDFPageWriter {
    static let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    private static let margin: CGFloat = 36

    private let context: UIGraphicsPDFRendererContext
    private(set) var cursorY: CGFloat

    var contentRect: CGRect {
        Self.pageRect.insetBy(dx: Self.margin, dy: Self.margin)
    }

    init(context: UIGraphicsPDFRendererContext) {
        self.context = context
        self.cursorY = Self.margin
        context.beginPage()
    }

    /// - Returns: `true` si tuvo que abrir una página nueva.
    @discardableResult
    mutating func ensureSpace(_ height: CGFloat) -> Bool {
        guard cursorY + height > contentRect.maxY else { return false }
        context.beginPage()
        cursorY = contentRect.minY
        return true
    }

    mutating func advance(by height: CGFloat) {
        cursorY += height
    }

    func drawRow(_ cells: [PDFCell], height: CGFloat, fill: UIColor? = nil) {
        let cgContext = context.cgContext
        var x = contentRect.minX
        for cell in cells {
            let rect = CGRect(x: x, y: cursorY, width: cell.width, height: height)
            if let fill {
                cgContext.setFillColor(fill.cgColor)
                cgContext.fill(rect)
            }
            cgContext.setStrokeColor(UIColor.black.cgColor)
            cgContext.setLineWidth(0.5)
            cgContext.stroke(rect)
            draw(cell.text, in: rect.insetBy(dx: 4, dy: 0), style: cell.style)
            x += cell.width
        }
    }

    func draw(_ text: String, in rect: CGRect, style: PDFTextStyle) {
        let attributes = style.attributes
        let lineHeight = style.font.lineHeight
        let textRect = CGRect(x: rect.minX, y: rect.midY - lineHeight / 2, width: rect.width, height: lineHeight)
        (text as NSString).draw(with: textRect, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil)
    }

    func draw(_ image: UIImage, fitting rect: CGRect) {
        guard image.size.width > 0, image.size.height > 0 else { return }
        let scale = min(rect.width / image.size.width, rect.height / image.size.height)
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.maxY - size.height)
        image.draw(in: CGRect(origin: origin, size: size))
    }

    func strokeLine(from start: CGPoint, to end: CGPoint) {
        let cgContext = context.cgContext
        cgContext.setStrokeColor(UIColor.black.cgColor)
        cgContext.setLineWidth(0.8)
        cgContext.move(to: start)
        cgContext.addLine(to: end)
        cgContext.strokePath()
    }
}
