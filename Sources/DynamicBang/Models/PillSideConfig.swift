import Foundation

struct PillSideConfig: Codable {
    var statusItems: [StatusItem]
    var shortcuts: [ShortcutItem]

    static let defaultLeft = PillSideConfig(
        statusItems: StatusItem.defaultLeft,
        shortcuts: ShortcutItem.defaultLeft
    )

    static let defaultRight = PillSideConfig(
        statusItems: StatusItem.defaultRight,
        shortcuts: ShortcutItem.defaultRight
    )
}
