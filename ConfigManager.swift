import Foundation

/// Loads configuration values from `Config.plist`, a local `.env` file, or
/// environment variables. Values loaded later override earlier ones, giving
/// precedence to environment variables for secure overrides.
final class ConfigManager {
    static let shared = ConfigManager()
    private var config: [String: String] = [:]

    private init() {
        // 1. Load from bundled Config.plist if it exists
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            for (key, value) in dict {
                if let stringValue = value as? String {
                    config[key] = stringValue
                }
            }
        } else {
            print("⚠️ Config.plist not found or unreadable")
        }

        // 2. Merge values from a local .env file if present
        if let envURL = Bundle.main.url(forResource: ".env", withExtension: nil),
           let contents = try? String(contentsOf: envURL) {
            let lines = contents.split(whereSeparator: \.isNewline)
            for line in lines {
                let parts = line.split(separator: "=", maxSplits: 1).map { String($0).trimmingCharacters(in: .whitespaces) }
                if parts.count == 2 {
                    config[parts[0]] = parts[1]
                }
            }
        }

        // 3. Override with environment variables
        for (key, value) in ProcessInfo.processInfo.environment {
            config[key] = value
        }
    }

    /// Testing initializer that allows injecting a custom configuration dictionary.
    /// This enables unit tests to supply mock values without relying on a real plist file.
    init(testingConfig: [String: Any]) {
        self.config = testingConfig
    }


    func stringValue(for key: String) -> String {
        config[key] ?? ""
    }
}
