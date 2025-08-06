import Foundation

@MainActor
final class PersistenceManager {
    static let shared = PersistenceManager()
    private let defaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    private enum Keys {
        static let exportCount = "exportCount"
        static let isPremiumUser = "isPremiumUser"
        static let projects = "projects"
    }

    func saveExportCount(_ count: Int) {
        defaults.set(count, forKey: Keys.exportCount)
    }

    func loadExportCount() -> Int {
        defaults.integer(forKey: Keys.exportCount)
    }

    func saveIsPremiumUser(_ value: Bool) {
        defaults.set(value, forKey: Keys.isPremiumUser)
    }

    func loadIsPremiumUser() -> Bool {
        defaults.bool(forKey: Keys.isPremiumUser)
    }

    func saveProjects(_ projects: [VideoProject]) {
        if let data = try? JSONEncoder().encode(projects) {
            defaults.set(data, forKey: Keys.projects)
        }
    }

    func loadProjects() -> [VideoProject] {
        guard let data = defaults.data(forKey: Keys.projects),
              let projects = try? JSONDecoder().decode([VideoProject].self, from: data) else {
            return []
        }
        return projects
    }
}

