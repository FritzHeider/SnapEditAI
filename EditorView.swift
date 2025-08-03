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
                    // Video Preview
                    VideoPreviewSection(
                        project: project,
                        isPlaying: $viewModel.isPlaying,
                        currentTime: $viewModel.currentTime,
                        duration: $viewModel.duration
                    )
                    
                    // Timeline
                    TimelineSection(
                        currentTime: $viewModel.currentTime,
                        duration: viewModel.duration,
                        project: project
                    )
                    
                    // Tools Section
                    ToolsSection(
                        selectedTool: $viewModel.selectedTool,
                        project: project
                    )
                    
                    // Bottom Actions
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
    }
}

struct VideoPreviewSection: View {
    let project: VideoProject
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var duration: Double
    
    var body: some View {
        ZStack {
            // Video Player Placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(9/16, contentMode: .fit)
                .overlay(
                    VStack {
                        if let url = project.videoURL {
                            Text("Video: \(url.lastPathComponent)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            isPlaying.toggle()
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                    }
                )
            
            // Captions Overlay
            VStack {
                Spacer()
                
                ForEach(project.captions.filter { caption in
                    currentTime >= caption.startTime && currentTime <= caption.endTime
                }) { caption in
                    Text(caption.text)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
        }
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
struct TimelineSection: View {
    @Binding var currentTime: Double
    let duration: Double
    let project: VideoProject
    
    var body: some View {
        VStack(spacing: 12) {
            // Time Scrubber
            VStack(spacing: 8) {
                HStack {
                    Text(formatTime(currentTime))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formatTime(duration))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Slider(value: $currentTime, in: 0...duration)
                    .accentColor(.purple)
            }
            
            // Timeline Tracks
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(0..<Int(duration/5), id: \.self) { index in
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 60)
                            .overlay(
                                Text("\(index * 5)s")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct ToolsSection: View {
    @Binding var selectedTool: EditorTool
    let project: VideoProject
    
    var body: some View {
        VStack(spacing: 16) {
            // Tool Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(EditorTool.allCases, id: \.self) { tool in
                        ToolButton(
                            tool: tool,
                            isSelected: selectedTool == tool
                        ) {
                            selectedTool = tool
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Tool Content
            Group {
                switch selectedTool {
                case .trim:
                    TrimToolView()
                case .captions:
                    CaptionsToolView(project: project)
                case .effects:
                    EffectsToolView()
                case .filters:
                    FiltersToolView()
                case .audio:
                    AudioToolView()
                }
            }
            .frame(height: 120)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.gray.opacity(0.05))
    }
}

struct ToolButton: View {
    let tool: EditorTool
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tool.icon)
                    .font(.title3)
                
                Text(tool.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .purple : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.purple.opacity(0.2) : Color.clear)
            )
        }
    }
}

struct TrimToolView: View {
    var body: some View {
        VStack {
            Text("Smart Trim")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                Button("Auto Trim") {
                    // AI auto-trim functionality
                }
                .buttonStyle(ToolActionButtonStyle())
                
                Button("Remove Silence") {
                    // Remove silent parts
                }
                .buttonStyle(ToolActionButtonStyle())
                
                Button("Jump Cuts") {
                    // Add jump cuts
                }
                .buttonStyle(ToolActionButtonStyle())
            }
        }
    }
}

struct CaptionsToolView: View {
    let project: VideoProject
    @State private var selectedStyle: CaptionStyle = .viral
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("AI Captions")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Generate") {
                    // Generate AI captions
                }
                .buttonStyle(ToolActionButtonStyle())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CaptionStyle.allCases, id: \.self) { style in
                        Button("\(style.emoji) \(style.rawValue)") {
                            selectedStyle = style
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            selectedStyle == style ? Color.purple : Color.gray.opacity(0.3)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct EffectsToolView: View {
    var body: some View {
        VStack {
            Text("Effects & Transitions")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    EffectButton(name: "Zoom In", icon: "plus.magnifyingglass")
                    EffectButton(name: "Fade", icon: "circle.dotted")
                    EffectButton(name: "Slide", icon: "arrow.right")
                    EffectButton(name: "Spin", icon: "arrow.clockwise")
                }
            }
        }
    }
}

struct EffectButton: View {
    let name: String
    let icon: String
    
    var body: some View {
        Button(action: {
            // Apply effect
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                
                Text(name)
                    .font(.caption2)
            }
            .foregroundColor(.white)
            .padding(8)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)
        }
    }
}

struct FiltersToolView: View {
    var body: some View {
        VStack {
            Text("Viral Filters")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["Cinematic", "Vintage", "Neon", "B&W", "Warm"], id: \.self) { filter in
                        Button(filter) {
                            // Apply filter
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct AudioToolView: View {
    var body: some View {
        VStack {
            Text("Audio")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                Button("Add Music") {
                    // Add background music
                }
                .buttonStyle(ToolActionButtonStyle())
                
                Button("Voice Enhance") {
                    // Enhance voice quality
                }
                .buttonStyle(ToolActionButtonStyle())
                
                Button("Remove Noise") {
                    // Remove background noise
                }
                .buttonStyle(ToolActionButtonStyle())
            }
        }
    }
}

struct BottomActionsSection: View {
    let project: VideoProject
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: EditorViewModel

    var body: some View {
        HStack(spacing: 16) {
            Button("Preview") {
                // Preview video
            }
            .buttonStyle(SecondaryActionButtonStyle())

            Spacer()

            Button("Export") {
                viewModel.export(appState: appState)
            }
            .buttonStyle(PrimaryActionButtonStyle())
            .disabled(!appState.canExport)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(Color.black)
    }
}

struct EmptyEditorState: View {
    @Binding var showingVideoPicker: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "video.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No Video Selected")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Import a video to start editing with AI")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Button("Import Video") {
                showingVideoPicker = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .frame(width: 200)
        }
        .padding()
    }
}

struct ToolActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [.purple, .pink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    EditorView()
        .environmentObject(AppState())
}

#endif

