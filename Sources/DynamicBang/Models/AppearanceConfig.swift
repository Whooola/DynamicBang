import SwiftUI

struct AppearanceConfig: Codable {
    var backgroundColor: CodableColor = CodableColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.85)
    var textColor: CodableColor = CodableColor.white
    var accentColor: CodableColor = CodableColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 1.0)
    var blurMaterial: BlurMaterial = .hudWindow
    var cornerRadius: CGFloat = 18
    var collapsedWidth: CGFloat = 120
    var expandedWidth: CGFloat = 240
    var pillHeight: CGFloat = 38
    var animationSpringResponse: CGFloat = 0.5
    var animationSpringDamping: CGFloat = 0.7

    static let `default` = AppearanceConfig()
}

enum BlurMaterial: String, Codable, CaseIterable {
    case hudWindow, menu, popover, sheet, tooltip, underWindowBackground
}
