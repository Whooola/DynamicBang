import SwiftUI

struct GeneralSettingsView: View {
    @Binding var config: Configuration

    var body: some View {
        Form {
            Section("热区设置") {
                HStack {
                    Text("热区向下延伸高度:")
                    Slider(value: $config.hotZoneHeight, in: 20...120, step: 10)
                    Text("\(Int(config.hotZoneHeight)) pt")
                        .frame(width: 40, alignment: .trailing)
                }

                HStack {
                    Text("展开防抖:")
                    Slider(value: .init(
                        get: { Double(config.expandDebounceMs) },
                        set: { config.expandDebounceMs = Int($0) }
                    ), in: 0...200, step: 5)
                    Text("\(config.expandDebounceMs) ms")
                        .frame(width: 50, alignment: .trailing)
                }

                HStack {
                    Text("收起防抖:")
                    Slider(value: .init(
                        get: { Double(config.collapseDebounceMs) },
                        set: { config.collapseDebounceMs = Int($0) }
                    ), in: 0...1000, step: 50)
                    Text("\(config.collapseDebounceMs) ms")
                        .frame(width: 50, alignment: .trailing)
                }
            }

            Section("行为") {
                Toggle("启动时自动隐藏 Dock 图标", isOn: .constant(true))
                    .disabled(true)
                Text("DynamicBang 作为菜单栏应用运行，始终隐藏 Dock 图标。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
    }
}
