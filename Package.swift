#if canImport(SwiftUI)
import SwiftUI
import AVFoundation

struct EditorView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = EditorViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let project = viewModel.currentProject {
                    VideoPreviewSection(
                        project: project,
                        isPlaying: $viewModel.isPlaying,
                        currentTime: $viewModel.currentTime,
                        duration: $viewModel.duration
                    )

                    TimelineSection(
                        currentTime: $viewModel.currentTime,
                        duration: viewModel.duration,
                        project: project
                    )

                    ToolsSection(
                        selectedTool: $viewModel.selectedTool,
                        project: project,
                        viewModel: viewModel
                    )

                    BottomActionsSection(project: project, viewModel: viewModel)
                } else {
                    EmptyEditorState(showingVideoPicker: $viewModel.showingVideoPicker)
                }
            }
            .background(Color.black)
            .navigationTitle("Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Import") {
                        viewModel.showingVideoPicker = true
                    }
                    .foregroundColor(.purple)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingVideoPicker) {
            VideoPickerView { url in
                viewModel.createNewProject(with: url, appState: appState)
            }
        }
        .sheet(isPresented: $viewModel.showingExportOptions) {
            if let project = viewModel.currentProject {
                ExportOptionsView(project: project)
            }
        }
        .onAppear {
            if viewModel.currentProject == nil {
                viewModel.currentProject = appState.currentProject
            }
        }
        .onChange(of: viewModel.currentProject) { newValue in
            appState.currentProject = newValue
        }
        .alert("Purchase Failed", isPresented: $viewModel.showingPurchaseError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(appState.subscriptionManager.lastError ?? "Unknown error")
        }
    }
}

#endif