import XCTest
import ViewInspector
@testable import SnapEditAI

extension OnboardingView: Inspectable {}
extension EditorView: Inspectable {}

final class ViewTests: XCTestCase {
    func testOnboardingViewShowsGetStartedButton() throws {
        let view = OnboardingView().environmentObject(AppState())
        let button = try view.inspect().find(button: "Get Started")
        XCTAssertNotNil(button)
    }

    func testEditorViewShowsExportButton() throws {
        let view = EditorView().environmentObject(AppState())
        let button = try view.inspect().find(button: "Export")
        XCTAssertNotNil(button)
    }
}
