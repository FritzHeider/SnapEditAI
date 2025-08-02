import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}

    private let defaults = UserDefaults.standard
    private let exportCountKey = "exportCount"
    private let isPremiumUserKey = "isPremiumUser"
    private let projectsKey = "projects"

    func saveAppState(exportCount: Int, isPremiumUser: Bool, projects: [VideoProject]) {
        defaults.set(exportCount, forKey: exportCountKey)
        defaults.set(isPremiumUser, forKey: isPremiumUserKey)
        if let data = try? JSONEncoder().encode(projects) {
            defaults.set(data, forKey: projectsKey)
        }
    }

    func loadAppState() -> (exportCount: Int, isPremiumUser: Bool, projects: [VideoProject]) {
        let exportCount = defaults.integer(forKey: exportCountKey)
        let isPremiumUser = defaults.bool(forKey: isPremiumUserKey)
        var projects: [VideoProject] = []
        if let data = defaults.data(forKey: projectsKey),
           let decoded = try? JSONDecoder().decode([VideoProject].self, from: data) {
            projects = decoded
        }
        return (exportCount, isPremiumUser, projects)
    }
}

