import AppKit
import SwiftUI

enum SettingsWindow {
    private static var window: NSWindow?

    static func open() {
        if window == nil {
            let vm = SettingsViewModel()
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 620, height: 460),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )
            window?.title = "DynamicBang 设置"
            window?.contentView = NSHostingView(rootView: SettingsRootView(viewModel: vm))
            window?.center()
            window?.setFrameAutosaveName("DynamicBangSettings")
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

struct SettingsRootView: View {
    @State var viewModel: SettingsViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralSettingsView(config: $viewModel.configuration)
                .tabItem { Label("通用", systemImage: "gear") }
                .tag(0)

            StatusItemsEditorView(
                title: "左侧状态项",
                items: $viewModel.configuration.leftPill.statusItems
            )
            .tabItem { Label("左侧药丸", systemImage: "pill.circle") }
            .tag(1)

            StatusItemsEditorView(
                title: "右侧状态项",
                items: $viewModel.configuration.rightPill.statusItems
            )
            .tabItem { Label("右侧药丸", systemImage: "pill.circle.fill") }
            .tag(2)

            ShortcutsEditorView(
                title: "左侧快捷操作",
                shortcuts: $viewModel.configuration.leftPill.shortcuts
            )
            .tabItem { Label("左侧快捷", systemImage: "square.grid.2x2") }
            .tag(3)

            ShortcutsEditorView(
                title: "右侧快捷操作",
                shortcuts: $viewModel.configuration.rightPill.shortcuts
            )
            .tabItem { Label("右侧快捷", systemImage: "square.grid.2x2.fill") }
            .tag(4)

            AppearanceEditorView(config: $viewModel.configuration.appearance)
                .tabItem { Label("外观", systemImage: "paintpalette") }
                .tag(5)

            FineTuneEditorView(config: $viewModel.configuration.fineTune)
                .tabItem { Label("微调", systemImage: "arrow.up.and.down.and.arrow.left.and.right") }
                .tag(6)
        }
        .padding()
        .frame(minWidth: 520, minHeight: 400)
    }
}
