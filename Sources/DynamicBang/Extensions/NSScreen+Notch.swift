import AppKit

extension NSScreen {
    var hasNotch: Bool {
        safeAreaInsets.top > 0
    }

    var notchHeight: CGFloat {
        safeAreaInsets.top
    }

    var notchLeftArea: CGRect? {
        guard hasNotch else { return nil }
        return auxiliaryTopLeftArea
    }

    var notchRightArea: CGRect? {
        guard hasNotch else { return nil }
        return auxiliaryTopRightArea
    }

    var notchCenterX: CGFloat {
        let leftMaxX = auxiliaryTopLeftArea?.maxX ?? 0
        let rightMinX = auxiliaryTopRightArea?.minX ?? frame.width
        return (leftMaxX + rightMinX) / 2
    }

    var notchWidth: CGFloat {
        let leftMaxX = auxiliaryTopLeftArea?.maxX ?? 0
        let rightMinX = auxiliaryTopRightArea?.minX ?? 0
        return max(0, rightMinX - leftMaxX)
    }
}
