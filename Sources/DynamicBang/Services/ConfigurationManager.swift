import Foundation

@Observable
final class ConfigurationManager {
    static let shared = ConfigurationManager()

    private let defaults = UserDefaults.standard
    private let configKey = "dynamicBang_config"

    var configuration: Configuration = .default

    func load() {
        guard let data = defaults.data(forKey: configKey),
              let config = try? JSONDecoder().decode(Configuration.self, from: data)
        else {
            configuration = .default
            return
        }
        configuration = config
    }

    func save() {
        guard let data = try? JSONEncoder().encode(configuration) else { return }
        defaults.set(data, forKey: configKey)
    }
}
