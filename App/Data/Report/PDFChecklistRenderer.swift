import UIKit

@MainActor
struct PDFChecklistRenderer: ChecklistReportRendering {
    private static let rowHeight: CGFloat = 16
    private static let headerFill = UIColor(white: 0.9, alpha: 1)

    func render(_ checklist: Checklist) throws -> Data {
        guard let signature = UIImage(data: checklist.signaturePNG) else {
            throw ChecklistError.reportGenerationFailed
        }

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextTitle as String: "Check-list de ensayos - \(checklist.movement.displayName)",
            kCGPDFContextAuthor as String: checklist.header.preparedBy,
            kCGPDFContextCreator as String: "Checklist Pangea"
        ]

        let renderer = UIGraphicsPDFRenderer(bounds: PDFPageWriter.pageRect, format: format)
        return renderer.pdfData { context in
            var writer = PDFPageWriter(context: context)
            drawTitle(checklist, writer: &writer)
            drawHeader(checklist, writer: &writer)
            for section in checklist.sections {
                drawSection(section, writer: &writer)
            }
            drawSignature(signature, checklist: checklist, writer: &writer)
        }
    }

    private func drawTitle(_ checklist: Checklist, writer: inout PDFPageWriter) {
        let width = writer.contentRect.width
        writer.drawRow([
            PDFCell(text: "PANGEA S.R.L. · Ciencias de la Tierra", width: width * 0.3, style: .caption),
            PDFCell(text: "CHECK-LIST DE ENSAYOS · \(checklist.movement.displayName.uppercased())", width: width * 0.7, style: .title)
        ], height: 40)
        writer.advance(by: 48)
    }

    private func drawHeader(_ checklist: Checklist, writer: inout PDFPageWriter) {
        let header = checklist.header
        let labelWidth = writer.contentRect.width * 0.17
        let valueWidth = writer.contentRect.width * 0.33
        let rows = [
            ("Proyecto", header.project, "Elaborado por", header.preparedBy),
            ("Destino", header.destination, "Acompañantes", header.companions),
            ("Fecha", checklist.date.formatted(date: .long, time: .shortened), "Movimiento", checklist.movement.displayName)
        ]
        for row in rows {
            writer.drawRow([
                PDFCell(text: row.0, width: labelWidth, style: .label),
                PDFCell(text: row.1, width: valueWidth, style: .body),
                PDFCell(text: row.2, width: labelWidth, style: .label),
                PDFCell(text: row.3, width: valueWidth, style: .body)
            ], height: 18)
            writer.advance(by: 18)
        }
        writer.advance(by: 16)
    }

    private func drawSection(_ section: ChecklistSection, writer: inout PDFPageWriter) {
        let height = Self.rowHeight
        writer.ensureSpace(height * 4)
        writer.drawRow([PDFCell(text: section.title.uppercased(), width: writer.contentRect.width, style: .labelCentered)],
                       height: height + 2, fill: Self.headerFill)
        writer.advance(by: height + 2)
        drawColumnHeader(writer: &writer)

        for item in section.items {
            if writer.ensureSpace(height) { drawColumnHeader(writer: &writer) }
            let columns = Self.columnWidths(for: writer.contentRect.width)
            writer.drawRow([
                PDFCell(text: item.name, width: columns.item, style: item.isChecked ? .body : .missing),
                PDFCell(text: item.barcode, width: columns.code, style: .bodyCentered),
                PDFCell(text: item.isChecked ? "✓" : "FALTA", width: columns.status, style: item.isChecked ? .bodyCentered : .missingCentered)
            ], height: height)
            writer.advance(by: height)
        }
        writer.advance(by: 12)
    }

    private func drawColumnHeader(writer: inout PDFPageWriter) {
        let columns = Self.columnWidths(for: writer.contentRect.width)
        writer.drawRow([
            PDFCell(text: "ITEM", width: columns.item, style: .labelCentered),
            PDFCell(text: "CÓDIGO", width: columns.code, style: .labelCentered),
            PDFCell(text: "CONTROL", width: columns.status, style: .labelCentered)
        ], height: Self.rowHeight)
        writer.advance(by: Self.rowHeight)
    }

    private func drawSignature(_ signature: UIImage, checklist: Checklist, writer: inout PDFPageWriter) {
        writer.ensureSpace(140)
        let items = checklist.allItems
        let checked = items.filter(\.isChecked).count
        let summary = "Elementos controlados: \(checked) de \(items.count)"
            + (checked < items.count ? " · Faltantes: \(items.count - checked)" : "")
        let content = writer.contentRect
        writer.draw(summary, in: CGRect(x: content.minX, y: writer.cursorY, width: content.width, height: 14), style: .label)
        writer.advance(by: 30)

        let box = CGRect(x: content.maxX - 220, y: writer.cursorY, width: 220, height: 70)
        writer.draw(signature, fitting: box)
        writer.strokeLine(from: CGPoint(x: box.minX, y: box.maxY + 4), to: CGPoint(x: box.maxX, y: box.maxY + 4))
        writer.draw("Firma: \(checklist.header.preparedBy)", in: CGRect(x: box.minX, y: box.maxY + 8, width: box.width, height: 14), style: .labelCentered)
        writer.advance(by: 100)
    }

    private static func columnWidths(for width: CGFloat) -> (item: CGFloat, code: CGFloat, status: CGFloat) {
        (item: width - 180, code: 100, status: 80)
    }
}
