// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ChecklistApp",
    platforms: [
        .iOS("17.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            exclude: ["AppInfo.plist"]
        )
    ],
    swiftLanguageVersions: [.version("6")]
)

#if canImport(AppleProductTypes)
import AppleProductTypes

package.products += [
    .iOSApplication(
        name: "Checklist",
        targets: ["AppModule"],
        bundleIdentifier: "com.softwarepangea.checklist",
        displayVersion: "0.1.0",
        bundleVersion: "1",
        appIcon: .placeholder(icon: .checkmark),
        accentColor: .presetColor(.blue),
        supportedDeviceFamilies: [
            .pad,
            .phone
        ],
        supportedInterfaceOrientations: [
            .portrait,
            .landscapeRight,
            .landscapeLeft,
            .portraitUpsideDown(.when(deviceFamilies: [.pad]))
        ],
        capabilities: [
            .camera(purposeString: "La cámara se usa para escanear el código de barras de cada elemento del checklist.")
        ],
        appCategory: .productivity,
        additionalInfoPlistContentFilePath: "AppInfo.plist"
    )
]
#endif
