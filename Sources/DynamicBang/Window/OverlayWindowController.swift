import AppKit
import SwiftUI

final class OverlayWindowController {
    let window: OverlayWindow
    let viewModel: PillViewModel
    private let screen: NSScreen
    private let side: PillSide
    private var hostingView: NSHostingView<PillContentView>?
    private var expandCheckTimer: Timer?
    private var previousExpandedState = false

    init(screen: NSScreen, side: PillSide, mouseTracker: MouseTracker) {
        self.screen = screen
        self.side = side
        let frame = NotchGeometryProvider.pillFrame(for: screen, side: side)
        window = OverlayWindow(screen: screen, frame: frame)
        viewModel = PillViewModel(side: side, mouseTracker: mouseTracker)

        let contentView = PillContentView(viewModel: viewModel)
        hostingView = NSHostingView(rootView: contentView)
        hostingView?.translatesAutoresizingMaskIntoConstraints = false

        if let hostingView = hostingView {
            window.contentView = hostingView
        }

        observeExpandState()
    }

    private func expandedFrame(expanded: Bool) -> NSRect {
        let config = ConfigurationManager.shared.configuration
        let ft = config.fineTune
        let appearance = config.appearance
        let nr = NotchGeometryProvider.notchCornerRadius(for: screen)
        let menuBarHeight = screen.notchHeight
        let menuBarBottom = screen.frame.height - menuBarHeight

        let w = (expanded ? appearance.expandedWidth : appearance.collapsedWidth) + nr
        let h = menuBarHeight

        let x: CGFloat
        let y: CGFloat
        switch side {
        case .right:
            y = menuBarBottom + ft.rightY
            if let rightArea = screen.notchRightArea {
                x = rightArea.minX - nr + ft.rightX
            } else {
                x = screen.frame.width - w
            }
        case .left:
            y = menuBarBottom + ft.leftY
            if let leftArea = screen.notchLeftArea {
                x = leftArea.maxX - appearance.collapsedWidth + ft.leftX
            } else {
                x = 0
            }
        }

        return NSRect(x: x, y: y, width: w, height: h)
    }

    private func observeExpandState() {
        expandCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            let isExpanded = self.viewModel.effectiveIsExpanded
            if isExpanded != self.previousExpandedState {
                self.previousExpandedState = isExpanded
                let newFrame = self.expandedFrame(expanded: isExpanded)
                if isExpanded {
                    self.window.setFrame(newFrame, display: true, animate: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        self.window.setIgnoresMouseEvents(false)
                    }
                } else {
                    self.window.setIgnoresMouseEvents(true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                        self.window.setFrame(newFrame, display: true, animate: false)
                    }
                }
            }
        }
    }

    func show() {
        window.orderFront(nil)
    }

    func hide() {
        window.orderOut(nil)
    }

    func close() {
        window.close()
    }

    func updateFrame(to frame: NSRect) {
        window.setFrame(frame, display: true, animate: false)
    }
}
