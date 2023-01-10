// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SwiftLintPlugin",
    platforms: [.macOS(.v12)],
    products: [
        .plugin(
            name: "SwiftLint",
            targets: ["SwiftLint"]
        ),
        .plugin(
            name: "SwiftLint Fix",
            targets: ["SwiftLintFix"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.50.3/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "abe7c0bb505d26c232b565c3b1b4a01a8d1a38d86846e788c4d02f0b1042a904"
        ),
        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .plugin(
            name: "SwiftLintFix",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [.writeToPackageDirectory(reason: "All correctable violations are fixed by SwiftLint.")]
            ),
            dependencies: ["SwiftLintBinary"]
        )
    ]
)
