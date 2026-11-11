import AVFoundation
import VisionKit

enum CameraAvailability: Equatable, Sendable {
    case checking
    case available
    case unsupported
    case denied

    /// Pide permiso de cámara si todavía no se pidió.
    @MainActor
    static func resolve() async -> CameraAvailability {
        guard DataScannerViewController.isSupported else { return .unsupported }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            guard await AVCaptureDevice.requestAccess(for: .video) else { return .denied }
        default:
            return .denied
        }
        return DataScannerViewController.isAvailable ? .available : .denied
    }
}
