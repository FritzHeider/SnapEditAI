import SwiftUI

class EditorViewModel: ObservableObject {
    @Published var showingVideoPicker = false
    @Published var currentProject: VideoProject?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 100
    @Published var selectedTool: EditorTool = .trim
    @Published var showingExportOptions = false

    func createNewProject(with videoURL: URL, appState: AppState) {
        let project = VideoProject(
            title: "New Video \(Date().formatted(.dateTime.hour().minute()))",
            videoURL: videoURL
        )
        currentProject = project
        appState.currentProject = project
    }

    func exportProject(appState: AppState) {
        guard appState.canExport else { return }
        showingExportOptions = true
        appState.incrementExportCount()
    }
}

