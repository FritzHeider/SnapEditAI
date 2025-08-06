import XCTest
@testable import SnapEditAI

final class ConfigManagerTests: XCTestCase {
    func testReturnsValueForExistingKey() async {
        let value = await MainActor.run { () -> String in
            let manager = ConfigManager(testingConfig: ["OPENAI_API_KEY": "123"])
            return manager.stringValue(for: "OPENAI_API_KEY")
        }
        XCTAssertEqual(value, "123")
    }

    func testReturnsEmptyStringForMissingKey() async {
        let value = await MainActor.run { () -> String in
            let manager = ConfigManager(testingConfig: [String: String]())
            return manager.stringValue(for: "MISSING")
        }
        XCTAssertEqual(value, "")
    }
}
