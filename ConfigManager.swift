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

    func stringValue(for key: String) -> String {
        config[key] as? String ?? ""
    }
}
