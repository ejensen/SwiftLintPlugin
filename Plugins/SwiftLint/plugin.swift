import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let sourceTarget = target as? SourceModuleTarget else {
            return []
        }
        return createBuildCommands(
            inputFiles: sourceTarget.sourceFiles(withSuffix: "swift").map(\.path),
            packageDirectory: context.package.directory,
            workingDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint"),
            targetName: target.name
        )
    }

    private func createBuildCommands(
        inputFiles: [Path],
        packageDirectory: Path,
        workingDirectory: Path,
        tool: PluginContext.Tool,
        targetName: String
    ) -> [Command] {
        if inputFiles.isEmpty {
            return []
        }

        let arguments = [
            "lint",
            "--quiet",
            "--force-exclude",
            "--cache-path", "\(workingDirectory)"
        ] + inputFiles.map(\.string)

        return [
            .prebuildCommand(
                displayName: "SwiftLint \(targetName)",
                executable: tool.path,
                arguments: arguments,
                outputFilesDirectory: workingDirectory.appending("Output")
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let inputFilePaths = target.inputFiles
            .filter { $0.type == .source && $0.path.extension == "swift" }
            .map(\.path)
        return createBuildCommands(
            inputFiles: inputFilePaths,
            packageDirectory: context.xcodeProject.directory,
            workingDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint"),
            targetName: target.displayName
        )
    }
}
#endif
