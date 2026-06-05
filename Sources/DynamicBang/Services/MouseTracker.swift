import Foundation
import AppKit

@Observable
final class MouseTracker {
    private(set) var globalMouseLocation: CGPoint = .zero
    private var globalMonitor: Any?
    private var pollingTimer: Timer?
    private var didShowPermissionAlert = false

    func start() {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged]
        ) { [weak self] _ in
            self?.globalMouseLocation = NSEvent.mouseLocation
        }

        if globalMonitor == nil {
            startPollingFallback()
            if !didShowPermissionAlert {
                didShowPermissionAlert = true
                DispatchQueue.main.async {
                    self.showAccessibilityAlert()
                }
            }
        }
    }

    func stop() {
        if let monitor = globalMonitor {
            NSEvent.removeMonitor(monitor)
            globalMonitor = nil
        }
        pollingTimer?.invalidate()
        pollingTimer = nil
    }

    private func startPollingFallback() {
        pollingTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0 / 30.0,
            repeats: true
        ) { [weak self] _ in
            self?.globalMouseLocation = NSEvent.mouseLocation
        }
    }

    private func showAccessibilityAlert() {
        let alert = NSAlert()
        alert.messageText = "需要辅助功能权限"
        alert.informativeText = """
        DynamicBang 需要辅助功能权限来流畅地追踪鼠标在刘海区域附近的移动。

        请在 系统设置 > 隐私与安全性 > 辅助功能 中启用 DynamicBang。

        现在将使用低功耗轮询模式运行，功能不受影响。
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "打开系统设置")
        alert.addButton(withTitle: "稍后")
        if alert.runModal() == .alertFirstButtonReturn {
            NSWorkspace.shared.open(
                URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
            )
        }
    }
}
