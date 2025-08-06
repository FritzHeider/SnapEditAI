import XCTest
@testable import SnapEditAI

final class AppStatePersistenceTests: XCTestCase {
    func testRoundTripPersistence() async {
        await MainActor.run {
            let suiteName = "AppStateTests"
            let defaults = UserDefaults(suiteName: suiteName)!
            defaults.removePersistentDomain(forName: suiteName)

            let persistence = PersistenceManager(userDefaults: defaults)
            let state = AppState(persistence: persistence)
            state.isPremiumUser = true
            state.exportCount = 2
            state.projects = [VideoProject(title: "Demo")]

            let reloaded = AppState(persistence: PersistenceManager(userDefaults: defaults))
            XCTAssertTrue(reloaded.isPremiumUser)
            XCTAssertEqual(reloaded.exportCount, 2)
            XCTAssertEqual(reloaded.projects.count, 1)
        }
    }
}
