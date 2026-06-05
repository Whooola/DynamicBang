import AppKit

enum ActionExecutor {
    static func execute(_ item: ShortcutItem) {
        switch item.action {
        case .screenshot:
            Process.launch("/usr/sbin/screencapture", ["-c"])
        case .screenshotArea:
            Process.launch("/usr/sbin/screencapture", ["-i", "-c"])
        case .screenshotWindow:
            Process.launch("/usr/sbin/screencapture", ["-w", "-c"])
        case .screenRecording:
            Process.launch("/usr/sbin/screencapture", ["-v"])
        case .lockScreen:
            Process.launch("/usr/bin/pmset", ["displaysleepnow"])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let sa = NSAppleScript(source: """
                tell application "System Events" to keystroke "q" using {command down, control down}
                """)
                sa?.executeAndReturnError(nil)
            }
        case .toggleDarkMode:
            let script = """
            tell application "System Events"
                tell appearance preferences
                    set dark mode to not dark mode
                end tell
            end tell
            """
            NSAppleScript(source: script)?.executeAndReturnError(nil)
        case .toggleDND:
            Process.launch("/usr/bin/defaults", [
                "write", "com.apple.ncprefs",
                "dnd_prefs", "-dict-add",
                "userPref", "-dict-add",
                "enabled", "-bool", "true"
            ])
            Process.launch("/usr/bin/killall", ["NotificationCenter"])
        case .openApp:
            guard let bundleID = item.payload else { return }
            if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
                NSWorkspace.shared.openApplication(
                    at: url,
                    configuration: NSWorkspace.OpenConfiguration()
                )
            }
        case .openURL:
            guard let urlString = item.payload, let url = URL(string: urlString) else { return }
            NSWorkspace.shared.open(url)
        case .runShortcut:
            guard let name = item.payload,
                  let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "shortcuts://run-shortcut?name=\(encoded)")
            else { return }
            NSWorkspace.shared.open(url)
        case .runShellScript:
            guard let script = item.payload else { return }
            Process.launch("/bin/bash", ["-c", script])
        case .colorPicker:
            NSColorPanel.shared.orderFront(nil)
        case .emojiPicker:
            NSApp.orderFrontCharacterPalette(nil)
        }
    }
}

private extension Process {
    static func launch(_ path: String, _ args: [String]) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = args
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        try? process.run()
    }
}
