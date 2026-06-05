import Foundation
import AppKit
import Combine

@Observable
final class PillViewModel: NSObject, @unchecked Sendable {
    let side: PillSide
    private let mouseTracker: MouseTracker
    private let statusProvider = StatusProvider()
    private let nowPlayingProvider = NowPlayingProvider()

    private(set) var isMouseInHotZone = false
    private(set) var effectiveIsExpanded = false
    private var expandWorkItem: DispatchWorkItem?
    private var collapseWorkItem: DispatchWorkItem?
    private var cancellables = Set<AnyCancellable>()

    var config: PillSideConfig {
        let full = ConfigurationManager.shared.configuration
        return side == .left ? full.leftPill : full.rightPill
    }

    var appearance: AppearanceConfig {
        ConfigurationManager.shared.configuration.appearance
    }

    var statusItems: [(StatusItem, String)] {
        statusProvider.formattedValues(for: config.statusItems)
    }

    var shortcuts: [ShortcutItem] {
        config.shortcuts.filter(\.isEnabled)
    }

    var nowPlayingText: String {
        nowPlayingProvider.displayText
    }

    var nowPlayingArt: NSImage? {
        nowPlayingProvider.albumArt
    }

    init(side: PillSide, mouseTracker: MouseTracker) {
        self.side = side
        self.mouseTracker = mouseTracker
        super.init()
        setupMouseTracking()
        statusProvider.startUpdating()
        nowPlayingProvider.start()
    }

    private func setupMouseTracking() {
        withObservationTracking {
            _ = mouseTracker.globalMouseLocation
        } onChange: {
            DispatchQueue.main.async { [weak self] in
                self?.evaluateMousePosition()
            }
        }

        Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            self?.evaluateMousePosition()
        }
    }

    private func evaluateMousePosition() {
        let point = mouseTracker.globalMouseLocation
        var inZone = false

        for screen in NSScreen.screens where screen.hasNotch {
            if NotchGeometryProvider.isPointInHotZone(point, screen: screen) {
                inZone = true
                break
            }
        }

        if inZone != isMouseInHotZone {
            isMouseInHotZone = inZone
            handleHotZoneChange(entered: inZone)
        }
    }

    private func handleHotZoneChange(entered: Bool) {
        let config = ConfigurationManager.shared.configuration
        expandWorkItem?.cancel()
        collapseWorkItem?.cancel()

        if entered {
            let work = DispatchWorkItem { [weak self] in
                self?.effectiveIsExpanded = true
            }
            expandWorkItem = work
            DispatchQueue.main.asyncAfter(
                deadline: .now() + .milliseconds(config.expandDebounceMs),
                execute: work
            )
        } else {
            let work = DispatchWorkItem { [weak self] in
                self?.effectiveIsExpanded = false
            }
            collapseWorkItem = work
            DispatchQueue.main.asyncAfter(
                deadline: .now() + .milliseconds(config.collapseDebounceMs),
                execute: work
            )
        }
    }
}
