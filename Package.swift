// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LinguaFlow",
    platforms: [
        .macOS(.v15)  // Apple Translation 需要 macOS 15+
    ],
    targets: [
        .executableTarget(
            name: "LinguaFlow",
            path: "LinguaFlow",
            exclude: ["Info.plist"],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
