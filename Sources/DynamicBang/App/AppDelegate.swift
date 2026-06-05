import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var windowManager: WindowManager!
    private var mouseTracker: MouseTracker!
    private var screenMonitor: ScreenMonitor!

    func applicationDidFinishLaunching(_ notification: Notification) {
        ConfigurationManager.shared.load()

        mouseTracker = MouseTracker()
        screenMonitor = ScreenMonitor()
        windowManager = WindowManager(mouseTracker: mouseTracker)

        setupStatusItem()
        mouseTracker.start()
        screenMonitor.start()
        windowManager.setupWindows()
    }

    func applicationWillTerminate(_ notification: Notification) {
        mouseTracker.stop()
        screenMonitor.stop()
        windowManager.removeAllWindows()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "capsule.portrait.inset.filled",
                accessibilityDescription: "DynamicBang"
            )
        }

        let menu = NSMenu()
        menu.addItem(
            NSMenuItem(
                title: "设置...",
                action: #selector(openSettings),
                keyEquivalent: ","
            )
        )
        menu.addItem(.separator())
        menu.addItem(
            NSMenuItem(
                title: "退出 DynamicBang",
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: "q"
            )
        )
        statusItem.menu = menu
    }

    @objc private func openSettings() {
        SettingsWindow.open()
    }
}
