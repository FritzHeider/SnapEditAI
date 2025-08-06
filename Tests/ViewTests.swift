import XCTest

#if canImport(SwiftUI)
import SwiftUI
import ViewInspector
@testable import SnapEditAI

extension OnboardingView: Inspectable {}
extension EditorView: Inspectable {}

final class ViewTests: XCTestCase {
    func testOnboardingViewRendersFirstPage() throws {
        let view = OnboardingView().environmentObject(AppState())
        XCTAssertNoThrow(try view.inspect().find(text: "AI-Powered Editing"))
    }

    func testEditorViewHasNavigationTitle() throws {
        let view = EditorView().environmentObject(AppState())
        let title = try view.inspect().navigationView().navigationBar().title().string()
        XCTAssertEqual(title, "Editor")
    }
}
#endif
