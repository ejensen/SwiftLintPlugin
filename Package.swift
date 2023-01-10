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
            url: "https://github.com/realm/SwiftLint/releases/download/0.50.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "487c57b5a39b80d64a20a2d052312c3f5ff1a4ea28e3cf5556e43c5b9a184c0c"
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
