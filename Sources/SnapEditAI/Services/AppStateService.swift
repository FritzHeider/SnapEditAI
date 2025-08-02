import Foundation

protocol AppStatePersisting {
    func save(_ state: AppState) throws
    func load() throws -> AppState
}

struct AppStateService: AppStatePersisting {
    private let userDefaults: UserDefaults
    private let key = "AppState"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func save(_ state: AppState) throws {
        let data = try JSONEncoder().encode(state)
        userDefaults.set(data, forKey: key)
    }

    func load() throws -> AppState {
        guard let data = userDefaults.data(forKey: key) else {
            return AppState()
        }
        return try JSONDecoder().decode(AppState.self, from: data)
    }
}
