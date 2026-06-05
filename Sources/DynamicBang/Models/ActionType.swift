import Foundation

enum ActionType: String, Codable, CaseIterable {
    case screenshot
    case screenshotArea
    case screenshotWindow
    case screenRecording
    case lockScreen
    case toggleDarkMode
    case toggleDND
    case openApp
    case openURL
    case runShortcut
    case runShellScript
    case colorPicker
    case emojiPicker
}
