import SwiftUI

struct StatusBadgeView: View {
    let title: String
    let value: String
    let type: StatusType

    var iconName: String {
        switch type {
        case .time: return "clock.fill"
        case .date: return "calendar"
        case .dayOfWeek: return "calendar.day.timeline.left"
        case .battery: return "battery.75"
        case .cpuUsage: return "cpu.fill"
        case .memoryUsage: return "memorychip.fill"
        case .nowPlaying: return "music.note"
        case .customScript: return "terminal.fill"
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: iconName)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
            Text(displayText)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.1))
        .clipShape(Capsule())
    }

    private var displayText: String {
        value.isEmpty ? title : value
    }
}
