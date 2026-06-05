import SwiftUI

struct AppearanceEditorView: View {
    @Binding var config: AppearanceConfig

    var body: some View {
        Form {
            Section("尺寸") {
                HStack {
                    Text("收起宽度:")
                    Slider(value: $config.collapsedWidth, in: 80...200, step: 10)
                    Text("\(Int(config.collapsedWidth)) pt")
                        .frame(width: 50, alignment: .trailing)
                }
                HStack {
                    Text("展开宽度:")
                    Slider(value: $config.expandedWidth, in: 160...400, step: 10)
                    Text("\(Int(config.expandedWidth)) pt")
                        .frame(width: 50, alignment: .trailing)
                }
                HStack {
                    Text("药丸高度:")
                    Slider(value: $config.pillHeight, in: 28...56, step: 2)
                    Text("\(Int(config.pillHeight)) pt")
                        .frame(width: 50, alignment: .trailing)
                }
                HStack {
                    Text("圆角:")
                    Slider(value: $config.cornerRadius, in: 8...28, step: 2)
                    Text("\(Int(config.cornerRadius)) pt")
                        .frame(width: 50, alignment: .trailing)
                }
            }

            Section("动画") {
                HStack {
                    Text("弹簧响应:")
                    Slider(value: $config.animationSpringResponse, in: 0.2...1.0, step: 0.1)
                    Text(String(format: "%.1f", config.animationSpringResponse))
                        .frame(width: 30, alignment: .trailing)
                }
                HStack {
                    Text("弹簧阻尼:")
                    Slider(value: $config.animationSpringDamping, in: 0.3...1.0, step: 0.05)
                    Text(String(format: "%.2f", config.animationSpringDamping))
                        .frame(width: 40, alignment: .trailing)
                }
            }

            Section("毛玻璃效果") {
                Picker("模糊材质", selection: $config.blurMaterial) {
                    ForEach(BlurMaterial.allCases, id: \.self) { mat in
                        Text(mat.displayName).tag(mat)
                    }
                }
            }

            Section("颜色") {
                ColorPicker("背景色", selection: Binding(
                    get: { config.backgroundColor.color },
                    set: { config.backgroundColor = CodableColor(
                        red: $0.rgba.red, green: $0.rgba.green,
                        blue: $0.rgba.blue, alpha: $0.rgba.alpha
                    )}
                ))
                ColorPicker("文字色", selection: Binding(
                    get: { config.textColor.color },
                    set: { config.textColor = CodableColor(
                        red: $0.rgba.red, green: $0.rgba.green,
                        blue: $0.rgba.blue, alpha: $0.rgba.alpha
                    )}
                ))
            }
        }
        .formStyle(.grouped)
    }
}

extension BlurMaterial {
    var displayName: String {
        switch self {
        case .hudWindow: return "HUD 窗口"
        case .menu: return "菜单"
        case .popover: return "弹出窗口"
        case .sheet: return "工作表"
        case .tooltip: return "工具提示"
        case .underWindowBackground: return "窗口底层"
        }
    }

    var nsMaterial: NSVisualEffectView.Material {
        switch self {
        case .hudWindow: return .hudWindow
        case .menu: return .menu
        case .popover: return .popover
        case .sheet: return .sheet
        case .tooltip: return .toolTip
        case .underWindowBackground: return .underWindowBackground
        }
    }
}

private extension Color {
    var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
        let nsColor = NSColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }
}
