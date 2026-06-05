import AppKit

final class ScreenMonitor {
    private var screenCount: Int = 0

    func start() {
        screenCount = NSScreen.screens.count
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenParametersChanged),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }

    func stop() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func screenParametersChanged() {
        let newCount = NSScreen.screens.count
        if newCount != screenCount {
            screenCount = newCount
        }
    }
}
