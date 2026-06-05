import Foundation

struct ShortcutItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String = ""
    var symbolName: String = "app.fill"
    var action: ActionType = .screenshot
    var payload: String?
    var isEnabled: Bool = true
    var order: Int = 0

    static let defaultLeft: [ShortcutItem] = [
        ShortcutItem(title: "截屏(全屏)", symbolName: "display", action: .screenshot, order: 0),
        ShortcutItem(title: "截屏(选区)", symbolName: "rectangle.dashed", action: .screenshotArea, order: 1),
        ShortcutItem(title: "截屏(窗口)", symbolName: "macwindow", action: .screenshotWindow, order: 2),
        ShortcutItem(title: "录屏", symbolName: "record.circle", action: .screenRecording, order: 3),
        ShortcutItem(title: "取色器", symbolName: "eyedropper", action: .colorPicker, order: 4),
    ]

    static let defaultRight: [ShortcutItem] = [
        ShortcutItem(title: "锁屏", symbolName: "lock.fill", action: .lockScreen, order: 0),
        ShortcutItem(title: "深色模式", symbolName: "circle.lefthalf.filled", action: .toggleDarkMode, order: 1),
        ShortcutItem(title: "勿扰", symbolName: "moon.fill", action: .toggleDND, order: 2),
        ShortcutItem(title: "表情", symbolName: "face.smiling", action: .emojiPicker, order: 3),
    ]
}
