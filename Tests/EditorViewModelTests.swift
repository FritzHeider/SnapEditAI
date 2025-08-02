import XCTest
@testable import SnapEditAI

final class EditorViewModelTests: XCTestCase {
    func testCreateNewProjectUpdatesAppState() {
        let vm = EditorViewModel()
        let appState = AppState()
        let url = URL(fileURLWithPath: "/tmp/video.mp4")
        vm.createNewProject(with: url, appState: appState)
        XCTAssertNotNil(vm.currentProject)
        XCTAssertEqual(appState.currentProject?.id, vm.currentProject?.id)
    }

    func testExportIncrementsCount() {
        let vm = EditorViewModel()
        let appState = AppState()
        vm.currentProject = VideoProject(title: "Test", videoURL: nil)
        vm.exportProject(appState: appState)
        XCTAssertTrue(vm.showingExportOptions)
        XCTAssertEqual(appState.exportCount, 1)
    }
}
