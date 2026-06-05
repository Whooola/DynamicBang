import Foundation
import IOKit.ps

@Observable
final class StatusProvider {
    private var timer: Timer?

    func formattedValues(for items: [StatusItem]) -> [(StatusItem, String)] {
        items.filter(\.isEnabled).map { item in
            (item, format(item))
        }
    }

    func startUpdating() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in }
    }

    func stopUpdating() {
        timer?.invalidate()
        timer = nil
    }

    private func format(_ item: StatusItem) -> String {
        switch item.type {
        case .time:
            let formatter = DateFormatter()
            formatter.dateFormat = item.format ?? "h:mm a"
            return formatter.string(from: Date())
        case .date:
            let formatter = DateFormatter()
            formatter.dateFormat = item.format ?? "MMM d"
            return formatter.string(from: Date())
        case .dayOfWeek:
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: Date())
        case .battery:
            return "\(getBatteryLevel())%"
        case .cpuUsage:
            return "CPU \(getCPUUsage())%"
        case .memoryUsage:
            return getMemoryUsage()
        case .nowPlaying:
            return ""
        case .customScript:
            return runCustomScript(item.format ?? "echo ok")
        }
    }

    private func getBatteryLevel() -> Int {
        let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [AnyObject]
        guard let source = sources?.first,
              let info = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any]
        else { return 0 }
        return (info[kIOPSCurrentCapacityKey] as? Int) ?? 0
    }

    private func getCPUUsage() -> Int {
        var info = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return 0 }

        let user = Double(info.cpu_ticks.0)
        let system = Double(info.cpu_ticks.1)
        let idle = Double(info.cpu_ticks.2)
        let total = user + system + idle
        guard total > 0 else { return 0 }
        return Int(((user + system) / total) * 100)
    }

    private func getMemoryUsage() -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .memory
        var info = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return "N/A" }
        let used = UInt64(info.active_count + info.wire_count) * UInt64(vm_page_size)
        return formatter.string(fromByteCount: Int64(used))
    }

    private func runCustomScript(_ script: String) -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", script]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        } catch {
            return "N/A"
        }
    }
}
