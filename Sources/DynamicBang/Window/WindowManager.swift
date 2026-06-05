import AppKit

enum PillSide {
    case left, right
}

final class WindowManager {
    private let mouseTracker: MouseTracker
    private var controllers: [OverlayWindowController] = []
    private var screenObserver: NSObjectProtocol?

    init(mouseTracker: MouseTracker) {
        self.mouseTracker = mouseTracker
    }

    func setupWindows() {
        createPillsForNotchedScreens()
        observeScreenChanges()
        observeFullScreenState()
    }

    private func createPillsForNotchedScreens() {
        removeAllWindows()
        controllers = []

        for screen in NSScreen.screens where screen.hasNotch {
            let leftController = OverlayWindowController(
                screen: screen,
                side: .left,
                mouseTracker: mouseTracker
            )
            let rightController = OverlayWindowController(
                screen: screen,
                side: .right,
                mouseTracker: mouseTracker
            )
            controllers.append(leftController)
            controllers.append(rightController)
            leftController.show()
            rightController.show()
        }
    }

    private func observeScreenChanges() {
        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.createPillsForNotchedScreens()
        }
    }

    private func observeFullScreenState() {
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleSpaceChange()
        }
    }

    private func handleSpaceChange() {
        let options = NSApp.currentSystemPresentationOptions
        let isFullScreen = options.contains(.autoHideMenuBar)
        controllers.forEach { isFullScreen ? $0.hide() : $0.show() }
    }

    func removeAllWindows() {
        controllers.forEach { $0.close() }
        controllers.removeAll()
    }
}
