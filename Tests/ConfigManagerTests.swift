import XCTest
@testable import SnapEditAI

final class ConfigManagerTests: XCTestCase {
    func testReturnsValueForExistingKey() {
        let manager = ConfigManager(testingConfig: ["OPENAI_API_KEY": "123"])
        XCTAssertEqual(manager.stringValue(for: "OPENAI_API_KEY"), "123")
    }

    func testReturnsEmptyStringForMissingKey() {
        let manager = ConfigManager(testingConfig: [:])
        XCTAssertEqual(manager.stringValue(for: "MISSING"), "")
    }
}
