import SwiftUI

struct StatusItemsEditorView: View {
    let title: String
    @Binding var items: [StatusItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            List {
                ForEach($items) { $item in
                    HStack {
                        Toggle("", isOn: $item.isEnabled)
                            .labelsHidden()
                        TextField("名称", text: $item.title)
                            .frame(width: 100)
                        Picker("类型", selection: $item.type) {
                            ForEach(StatusType.allCases, id: \.self) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .frame(width: 120)
                        if item.type == .time || item.type == .date || item.type == .customScript {
                            TextField("格式", text: Binding(
                                get: { item.format ?? "" },
                                set: { item.format = $0.isEmpty ? nil : $0 }
                            ))
                            .frame(width: 80)
                        }
                    }
                }
                .onMove { source, destination in
                    items.move(fromOffsets: source, toOffset: destination)
                }
            }

            HStack {
                Button("添加") {
                    items.append(StatusItem(title: "New", type: .time, order: items.count))
                }
                Button("恢复默认") {
                    let defaults = StatusItem.defaultLeft
                    items = defaults
                }
            }
        }
        .padding()
    }
}

private extension StatusType {
    var displayName: String {
        switch self {
        case .time: return "时间"
        case .date: return "日期"
        case .dayOfWeek: return "星期"
        case .battery: return "电池"
        case .cpuUsage: return "CPU"
        case .memoryUsage: return "内存"
        case .nowPlaying: return "正在播放"
        case .customScript: return "自定义脚本"
        }
    }
}
