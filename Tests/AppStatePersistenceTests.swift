import XCTest
@testable import SnapEditAI

final class AppStatePersistenceTests: XCTestCase {
    override func tearDown() {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("appstate.json")
        try? FileManager.default.removeItem(at: url)
        super.tearDown()
    }

    func testSaveAndLoadState() throws {
        let state = AppState()
        state.isOnboardingComplete = true
        state.isPremiumUser = true
        state.exportCount = 2
        try state.save()

        let loaded = AppState.load()
        XCTAssertTrue(loaded.isOnboardingComplete)
        XCTAssertTrue(loaded.isPremiumUser)
        XCTAssertEqual(loaded.exportCount, 2)
    }
}
