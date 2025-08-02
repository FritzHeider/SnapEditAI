import SwiftUI
import Foundation

@main
struct SnapEditAIApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

class AppState: ObservableObject {
    private let persistence = PersistenceManager.shared

    @Published var isOnboardingComplete = false
    @Published var isPremiumUser: Bool = false {
        didSet { saveState() }
    }
    @Published var currentProject: VideoProject?
    @Published var exportCount: Int = 0 {
        didSet { saveState() }
    }
    @Published var projects: [VideoProject] = [] {
        didSet { saveState() }
    }

    let maxFreeExports = 3

    var canExport: Bool {
        isPremiumUser || exportCount < maxFreeExports
    }

    init() {
        let loaded = persistence.loadAppState()
        self.exportCount = loaded.exportCount
        self.isPremiumUser = loaded.isPremiumUser
        self.projects = loaded.projects
    }

    private func saveState() {
        persistence.saveAppState(exportCount: exportCount, isPremiumUser: isPremiumUser, projects: projects)
    }

    func incrementExportCount() {
        if !isPremiumUser {
            exportCount += 1
        }
    }
}

struct VideoProject: Identifiable, Codable {
    let id: UUID
    var title: String
    var videoURL: URL?
    var captions: [Caption] = []
    var effects: [VideoEffect] = []
    var createdAt: Date = Date()

    init(id: UUID = UUID(), title: String, videoURL: URL? = nil, captions: [Caption] = [], effects: [VideoEffect] = [], createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.videoURL = videoURL
        self.captions = captions
        self.effects = effects
        self.createdAt = createdAt
    }
}

struct Caption: Identifiable, Codable {
    let id: UUID
    var text: String
    var startTime: Double
    var endTime: Double
    var style: CaptionStyle = .viral

    init(id: UUID = UUID(), text: String, startTime: Double, endTime: Double, style: CaptionStyle = .viral) {
        self.id = id
        self.text = text
        self.startTime = startTime
        self.endTime = endTime
        self.style = style
    }
}

enum CaptionStyle: String, CaseIterable, Codable {
    case viral = "Viral"
    case minimal = "Minimal"
    case podcast = "Podcast"
    case storytime = "Storytime"

    var emoji: String {
        switch self {
        case .viral: return "🔥"
        case .minimal: return "✨"
        case .podcast: return "🎙️"
        case .storytime: return "📖"
        }
    }
}

struct VideoEffect: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: EffectType
    var intensity: Double = 1.0

    init(id: UUID = UUID(), name: String, type: EffectType, intensity: Double = 1.0) {
        self.id = id
        self.name = name
        self.type = type
        self.intensity = intensity
    }
}

enum EffectType: String, CaseIterable, Codable {
    case transition = "Transition"
    case filter = "Filter"
    case overlay = "Overlay"
    case animation = "Animation"
}

