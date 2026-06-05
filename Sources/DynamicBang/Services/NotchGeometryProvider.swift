import AppKit

enum NotchGeometryProvider {
    static let pillSpacing: CGFloat = 0

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
        let leftFrame = pillFrame(for: screen, side: .left)
        let rightFrame = pillFrame(for: screen, side: .right)
        let leftEdge = leftFrame.minX
        let rightEdge = rightFrame.maxX

        let menuBarHeight = screen.notchHeight
        let menuBarBottom = screen.frame.height - menuBarHeight
        let totalHeight = menuBarHeight + config.hotZoneHeight
        let hotZoneBottom = menuBarBottom - config.hotZoneHeight

        return NSRect(
            x: leftEdge - 10,
            y: hotZoneBottom,
            width: (rightEdge - leftEdge) + 20,
            height: totalHeight
        )
    }

    static func isPointInHotZone(_ point: CGPoint, screen: NSScreen) -> Bool {
        let screenPoint = CGPoint(x: point.x - screen.frame.origin.x,
                                   y: point.y - screen.frame.origin.y)
        return hotZoneRect(for: screen).contains(screenPoint)
    }
}
