import Foundation

struct StatusItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String = ""
    var type: StatusType = .time
    var format: String?
    var isEnabled: Bool = true
    var order: Int = 0

    static let defaultLeft: [StatusItem] = [
        StatusItem(title: "Time", type: .time, format: "h:mm a", order: 0),
        StatusItem(title: "Now Playing", type: .nowPlaying, order: 1),
    ]

    static let defaultRight: [StatusItem] = [
        StatusItem(title: "Battery", type: .battery, order: 0),
        StatusItem(title: "CPU", type: .cpuUsage, order: 1),
    ]
}
