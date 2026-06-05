// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DynamicBang",
    platforms: [
        .macOS("14.0")
    ],
    targets: [
        .executableTarget(
            name: "DynamicBang",
            path: "Sources/DynamicBang",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
