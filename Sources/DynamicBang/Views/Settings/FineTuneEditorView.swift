import SwiftUI

struct FineTuneEditorView: View {
    @Binding var config: FineTuneConfig

    var body: some View {
        Form {
            Section("左侧药丸微调") {
                HStack {
                    Text("水平偏移:")
                    Slider(value: $config.leftX, in: -10...10, step: 1)
                    Text("\(Int(config.leftX)) pt")
                        .frame(width: 40, alignment: .trailing)
                }
                HStack {
                    Text("垂直偏移:")
                    Slider(value: $config.leftY, in: -10...10, step: 1)
                    Text("\(Int(config.leftY)) pt")
                        .frame(width: 40, alignment: .trailing)
                }
            }
            Section("右侧药丸微调") {
                HStack {
                    Text("水平偏移:")
                    Slider(value: $config.rightX, in: -10...10, step: 1)
                    Text("\(Int(config.rightX)) pt")
                        .frame(width: 40, alignment: .trailing)
                }
                HStack {
                    Text("垂直偏移:")
                    Slider(value: $config.rightY, in: -10...10, step: 1)
                    Text("\(Int(config.rightY)) pt")
                        .frame(width: 40, alignment: .trailing)
                }
            }
            Section("说明") {
                Text("正值：水平向右/垂直向上移动。负值：水平向左/垂直向下移动。修改后即时生效。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
    }
}
