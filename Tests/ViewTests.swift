import XCTest

#if canImport(SwiftUI)
import SwiftUI
import ViewInspector
@testable import SnapEditAI

extension OnboardingView: Inspectable {}
extension EditorView: Inspectable {}
extension TemplatesView: Inspectable {}

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

    @MainActor
    func testTemplatesViewShowsTrendingTracksAfterFetch() async throws {
        let json = """
        { "feed": { "results": [ { "name": "Mock Song", "artistName": "Mock Artist", "previewUrl": "https://example.com/preview.mp3" } ] } }
        """.data(using: .utf8)!
        let service = TrendService(overrideData: json)
        let viewModel = TemplatesViewModel(trendService: service)
        let view = TemplatesView(viewModel: viewModel)
        ViewHosting.host(view: view)
        defer { ViewHosting.expel() }

        await viewModel.fetchTrendingAudio()
        try await Task.sleep(nanoseconds: 10_000_000)

        XCTAssertNoThrow(try view.inspect().find(text: "Mock Song"))
        XCTAssertNoThrow(try view.inspect().find(text: "Mock Artist"))
    }
}
#endif
