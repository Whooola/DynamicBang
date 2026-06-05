import Foundation
import SwiftUI

@Observable
final class SettingsViewModel {
    var configuration: Configuration {
        didSet { ConfigurationManager.shared.configuration = configuration }
    }

    init() {
        configuration = ConfigurationManager.shared.configuration
    }

    func save() {
        ConfigurationManager.shared.configuration = configuration
        ConfigurationManager.shared.save()
    }

    func reset() {
        configuration = .default
        save()
    }
}
