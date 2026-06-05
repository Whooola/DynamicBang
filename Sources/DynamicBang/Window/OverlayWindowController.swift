import AppKit
import SwiftUI

final class OverlayWindowController {
    let window: OverlayWindow
    let viewModel: PillViewModel
    private var hostingView: NSHostingView<PillContentView>?
    private var expandCheckTimer: Timer?
    private var previousExpandedState = false

    init(screen: NSScreen, side: PillSide, mouseTracker: MouseTracker) {
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

    private func observeExpandState() {
        expandCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            let isExpanded = self.viewModel.effectiveIsExpanded
            if isExpanded != self.previousExpandedState {
                self.previousExpandedState = isExpanded
                if isExpanded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        self.window.setIgnoresMouseEvents(false)
                    }
                } else {
                    self.window.setIgnoresMouseEvents(true)
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
