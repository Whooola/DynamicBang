import Foundation

struct Configuration: Codable {
    var leftPill: PillSideConfig = .defaultLeft
    var rightPill: PillSideConfig = .defaultRight
    var appearance: AppearanceConfig = .default
    var hotZoneHeight: CGFloat = 60
    var expandDebounceMs: Int = 5
    var collapseDebounceMs: Int = 200

    static let `default` = Configuration()
}
