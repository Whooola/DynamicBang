import Foundation

enum StatusType: String, Codable, CaseIterable {
    case time
    case date
    case dayOfWeek
    case battery
    case cpuUsage
    case memoryUsage
    case nowPlaying
    case customScript
}
