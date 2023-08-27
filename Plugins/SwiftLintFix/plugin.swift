import PackagePlugin
import Foundation

@main
struct SwiftLintFixPlugin: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let executableURL = try URL(fileURLWithPath: context.tool(named: "swiftlint").path.string)
        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["--fix"]

        try process.run()
        process.waitUntilExit()
        if process.terminationReason == .exit, process.terminationStatus == 0 {
            Diagnostics.remark("SwiftLint corrected \(context.package.displayName)")
        } else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("swift-lint --fix \(context.package.displayName) invocation failed: \(problem)")
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintFixPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        let executableURL = try URL(fileURLWithPath: context.tool(named: "swiftlint").path.string)
        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["--fix"]
        try process.run()
        process.waitUntilExit()
        
        if process.terminationReason == .exit, process.terminationStatus == 0 {
            Diagnostics.remark("SwiftLint corrected \(context.xcodeProject.displayName)")
        } else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("swift-lint --fix \(context.xcodeProject.displayName) invocation failed: \(problem)")
        }
    }
}
#endif
