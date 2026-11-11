// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ChecklistKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "ChecklistKit", targets: ["ChecklistKit"])
    ],
    targets: [
        .target(
            name: "ChecklistKit",
            path: "App",
            exclude: ["ChecklistApp.swift"]
        )
    ]
)
