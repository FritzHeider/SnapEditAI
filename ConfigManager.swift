import Foundation

final class ConfigManager {
    static let shared = ConfigManager()
    private var config: [String: Any] = [:]

    private init() {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            config = dict
        } else {
            print("⚠️ Config.plist not found or unreadable")
        }
    }

    /// Testing initializer that allows injecting a custom configuration dictionary.
    /// This enables unit tests to supply mock values without relying on a real plist file.
    init(testingConfig: [String: Any]) {
        self.config = testingConfig
    }

    func stringValue(for key: String) -> String {
        config[key] as? String ?? ""
    }
}
