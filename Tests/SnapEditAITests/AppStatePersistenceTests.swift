import XCTest
@testable import SnapEditAI

final class AppStatePersistenceTests: XCTestCase {
    func testSavingAndLoadingAppState() throws {
        let suiteName = UUID().uuidString
        let defaults = UserDefaults(suiteName: suiteName)!
        let service = AppStateService(userDefaults: defaults)

        let state = AppState()
        state.isOnboardingComplete = true
        state.exportCount = 2
        try service.save(state)

        let loaded = try service.load()
        XCTAssertTrue(loaded.isOnboardingComplete)
        XCTAssertEqual(loaded.exportCount, 2)
    }

    func testExportLimitForFreeUsers() {
        let state = AppState()
        XCTAssertTrue(state.canExport)
        state.exportCount = 2
        XCTAssertTrue(state.canExport)
        state.incrementExportCount()
        XCTAssertFalse(state.canExport)
    }
}
