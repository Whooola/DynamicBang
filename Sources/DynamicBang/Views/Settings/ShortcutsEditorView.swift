import SwiftUI

struct ShortcutsEditorView: View {
    let title: String
    @Binding var shortcuts: [ShortcutItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            List {
                ForEach($shortcuts) { $shortcut in
                    HStack {
                        Toggle("", isOn: $shortcut.isEnabled)
                            .labelsHidden()
                        TextField("名称", text: $shortcut.title)
                            .frame(width: 100)
                        TextField("图标", text: $shortcut.symbolName)
                            .frame(width: 100)
                        Image(systemName: shortcut.symbolName)
                            .frame(width: 20)
                        Picker("动作", selection: $shortcut.action) {
                            ForEach(ActionType.allCases, id: \.self) { action in
                                Text(action.displayName).tag(action)
                            }
                        }
                        .frame(width: 120)
                        if shortcut.action == .openApp || shortcut.action == .openURL ||
                           shortcut.action == .runShortcut || shortcut.action == .runShellScript {
                            TextField("参数", text: Binding(
                                get: { shortcut.payload ?? "" },
                                set: { shortcut.payload = $0.isEmpty ? nil : $0 }
                            ))
                            .frame(width: 100)
                        }
                    }
                }
                .onMove { source, destination in
                    shortcuts.move(fromOffsets: source, toOffset: destination)
                }
            }

            HStack {
                Button("添加") {
                    shortcuts.append(ShortcutItem(
                        title: "新操作",
                        symbolName: "app.fill",
                        action: .screenshot,
                        order: shortcuts.count
                    ))
                }
                Button("恢复默认") {
                    shortcuts = ShortcutItem.defaultLeft
                }
            }
        }
        .padding()
    }
}

private extension ActionType {
    var displayName: String {
        switch self {
        case .screenshot: return "截屏(全屏)"
        case .screenshotArea: return "截屏(选区)"
        case .screenshotWindow: return "截屏(窗口)"
        case .screenRecording: return "录屏"
        case .lockScreen: return "锁屏"
        case .toggleDarkMode: return "深色模式"
        case .toggleDND: return "勿扰"
        case .openApp: return "启动应用"
        case .openURL: return "打开链接"
        case .runShortcut: return "快捷指令"
        case .runShellScript: return "Shell脚本"
        case .colorPicker: return "取色器"
        case .emojiPicker: return "表情面板"
        }
    }
}
