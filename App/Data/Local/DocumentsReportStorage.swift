import Foundation

/// Guarda los reportes en Documents/Checklists, carpeta visible desde la app Archivos.
actor DocumentsReportStorage: ReportStorageProtocol {
    private let directory: URL

    init(directory: URL = DocumentsReportStorage.defaultDirectory) {
        self.directory = directory
    }

    static var defaultDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        return documents.appending(path: "Checklists", directoryHint: .isDirectory)
    }

    func save(_ data: Data, fileName: String) throws -> URL {
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let destination = availableURL(for: fileName)
            try data.write(to: destination, options: [.atomic, .completeFileProtectionUnlessOpen])
            return destination
        } catch {
            throw ChecklistError.storageFailed
        }
    }

    private func availableURL(for fileName: String) -> URL {
        let candidate = directory.appending(path: fileName)
        guard FileManager.default.fileExists(atPath: candidate.path()) else { return candidate }

        let baseName = candidate.deletingPathExtension().lastPathComponent
        let fileExtension = candidate.pathExtension
        var index = 2
        while true {
            let next = directory.appending(path: "\(baseName)-\(index).\(fileExtension)")
            if !FileManager.default.fileExists(atPath: next.path()) { return next }
            index += 1
        }
    }
}
