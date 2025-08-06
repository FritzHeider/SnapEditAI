import XCTest
@testable import SnapEditAI

final class EditorViewModelTests: XCTestCase {
    func testCreateNewProjectSetsProject() async {
        await MainActor.run {
            let appState = AppState()
            let vm = EditorViewModel()
            let url = URL(fileURLWithPath: "/tmp/video.mp4")
            vm.createNewProject(with: url, appState: appState)
            XCTAssertEqual(vm.currentProject?.videoURL, url)
            XCTAssertEqual(appState.currentProject?.videoURL, url)
        }
    }

    func testExportUpdatesStateWhenAllowed() async {
        await MainActor.run {
            let appState = AppState()
            appState.subscriptionManager.isPremiumUser = true
            let vm = EditorViewModel()
            vm.export(appState: appState)
            XCTAssertTrue(vm.showingExportOptions)
        }
    }
}
