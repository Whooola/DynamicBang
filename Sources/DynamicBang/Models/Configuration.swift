import Foundation

struct Configuration: Codable {
    var leftPill: PillSideConfig = .defaultLeft
    var rightPill: PillSideConfig = .defaultRight
    var appearance: AppearanceConfig = .default
    var hotZoneHeight: CGFloat = 60
    var expandDebounceMs: Int = 5
    var collapseDebounceMs: Int = 200
    var fineTune: FineTuneConfig = .default

    static let `default` = Configuration()
}

struct FineTuneConfig: Codable {
    var leftX: CGFloat = 1
    var leftY: CGFloat = 1
    var rightX: CGFloat = -3
    var rightY: CGFloat = 1

    static let `default` = FineTuneConfig()
}
