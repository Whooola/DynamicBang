import AppKit

enum NotchGeometryProvider {

    static func notchCornerRadius(for screen: NSScreen) -> CGFloat {
        round(screen.safeAreaInsets.top * 0.3)
    }

    static var notchCornerRadius: CGFloat {
        if let screen = NSScreen.screens.first(where: { $0.hasNotch }) {
            return notchCornerRadius(for: screen)
        }
        return 11
    }

    static func pillFrame(for screen: NSScreen, side: PillSide) -> NSRect {
        let config = ConfigurationManager.shared.configuration
        let appearance = config.appearance
        let nr = notchCornerRadius(for: screen)
        let menuBarHeight = screen.notchHeight
        let menuBarBottom = screen.frame.height - menuBarHeight

        let collapsedWidth = appearance.collapsedWidth + nr
        let pillHeight = menuBarHeight
        let y = menuBarBottom + 1

        let x: CGFloat
        switch side {
        case .right:
            if let rightArea = screen.notchRightArea {
                x = rightArea.minX - nr
            } else {
                x = screen.frame.width - collapsedWidth
            }
        case .left:
            if let leftArea = screen.notchLeftArea {
                x = leftArea.maxX - appearance.collapsedWidth
            } else {
                x = 0
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
