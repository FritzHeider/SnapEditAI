import Foundation
#if canImport(Combine)
import Combine
#endif

class AppState: ObservableObject {
    @Published var isOnboardingComplete = false
    @Published var isPremiumUser = false
    @Published var currentProject: VideoProject?
    @Published var exportCount = 0

    let maxFreeExports = 3

    // API keys loaded from secure Config.plist
    let openAIKey: String
    let whisperKey: String
    let firebaseConfig: String
    let revenueCatKey: String

    init() {
        let config = ConfigManager.shared
        openAIKey = config.stringValue(for: "OPENAI_API_KEY")
        whisperKey = config.stringValue(for: "WHISPER_API_KEY")
        firebaseConfig = config.stringValue(for: "FIREBASE_CONFIG")
        revenueCatKey = config.stringValue(for: "REVENUECAT_KEY")
    }

    var canExport: Bool {
        isPremiumUser || exportCount < maxFreeExports
    }

    func incrementExportCount() {
        if !isPremiumUser {
            exportCount += 1
        }
    }
}

struct VideoProject: Identifiable {
    let id = UUID()
    var title: String
    var videoURL: URL?
    var captions: [Caption] = []
    var effects: [VideoEffect] = []
    var createdAt = Date()
}

struct Caption: Identifiable {
    let id = UUID()
    var text: String
    var startTime: Double
    var endTime: Double
    var style: CaptionStyle = .viral
}

enum CaptionStyle: String, CaseIterable {
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

struct VideoEffect: Identifiable {
    let id = UUID()
    var name: String
    var type: EffectType
    var intensity: Double = 1.0
}

enum EffectType: String, CaseIterable {
    case transition = "Transition"
    case filter = "Filter"
    case overlay = "Overlay"
    case animation = "Animation"
}

enum EditorTool: String, CaseIterable {
    case trim = "Trim"
    case captions = "Captions"
    case effects = "Effects"
    case filters = "Filters"
    case audio = "Audio"

    var icon: String {
        switch self {
        case .trim: return "scissors"
        case .captions: return "text.bubble"
        case .effects: return "wand.and.stars"
        case .filters: return "camera.filters"
        case .audio: return "speaker.wave.2"
        }
    }
}

enum TemplateCategory: String, CaseIterable {
    case trending = "Trending"
    case educational = "Educational"
    case business = "Business"
    case lifestyle = "Lifestyle"

    var icon: String {
        switch self {
        case .trending: return "flame.fill"
        case .educational: return "graduationcap.fill"
        case .business: return "briefcase.fill"
        case .lifestyle: return "heart.fill"
        }
    }
}

struct Template: Identifiable {
    let id = UUID()
    let name: String
    let category: TemplateCategory
    let thumbnail: String
}
