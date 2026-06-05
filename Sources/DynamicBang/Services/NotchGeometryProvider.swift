import AppKit

enum NotchGeometryProvider {
    static let pillSpacing: CGFloat = 6

    static func pillFrame(for screen: NSScreen, side: PillSide) -> NSRect {
        let config = ConfigurationManager.shared.configuration
        let appearance = config.appearance
        let menuBarHeight = screen.notchHeight
        let menuBarBottom = screen.frame.height - menuBarHeight

        let collapsedWidth = appearance.collapsedWidth
        let pillHeight = appearance.pillHeight
        let y = menuBarBottom + (menuBarHeight - pillHeight) / 2

        let x: CGFloat
        switch side {
        case .right:
            if let rightArea = screen.notchRightArea {
                x = rightArea.minX + pillSpacing
            } else {
                x = screen.frame.width - collapsedWidth - pillSpacing
            }
        case .left:
            if let leftArea = screen.notchLeftArea {
                x = leftArea.maxX - collapsedWidth - pillSpacing
            } else {
                x = pillSpacing
            }
        }

        return NSRect(x: x, y: y, width: collapsedWidth, height: pillHeight)
    }

    static func hotZoneRect(for screen: NSScreen) -> NSRect {
        let config = ConfigurationManager.shared.configuration
        let leftMaxX = screen.notchLeftArea?.maxX ?? 0
        let rightMinX = screen.notchRightArea?.minX ?? 0
        let notchWidth = max(0, rightMinX - leftMaxX)
        let notchX = (leftMaxX + rightMinX) / 2

        let padding: CGFloat = 20
        let menuBarHeight = screen.notchHeight
        let menuBarBottom = screen.frame.height - menuBarHeight
        let totalHeight = menuBarHeight + config.hotZoneHeight
        let hotZoneBottom = menuBarBottom - config.hotZoneHeight

        return NSRect(
            x: notchX - notchWidth / 2 - padding,
            y: hotZoneBottom,
            width: notchWidth + padding * 2,
            height: totalHeight
        )
    }

    static func isPointInHotZone(_ point: CGPoint, screen: NSScreen) -> Bool {
        let screenPoint = CGPoint(x: point.x - screen.frame.origin.x,
                                   y: point.y - screen.frame.origin.y)
        return hotZoneRect(for: screen).contains(screenPoint)
    }
}
