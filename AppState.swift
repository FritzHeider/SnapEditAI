import Foundation
#if canImport(Combine)
import Combine
#endif

@MainActor
class AppState: ObservableObject {
    @Published var isOnboardingComplete = false
    @Published var isPremiumUser: Bool {
        didSet { persistence.saveIsPremiumUser(isPremiumUser) }
    }
    @Published var currentProject: VideoProject?
    @Published var exportCount: Int {
        didSet { persistence.saveExportCount(exportCount) }
    }
    @Published var projects: [VideoProject] {
        didSet { persistence.saveProjects(projects) }
    }

    let maxFreeExports = 3

    let subscriptionManager = SubscriptionManager.shared

    // API keys loaded from secure Config.plist
    let openAIKey: String
    let whisperKey: String
    let firebaseConfig: String
    let revenueCatKey: String

    private let persistence: PersistenceManager

    init(persistence: PersistenceManager = .shared) {
        self.persistence = persistence
        self.isPremiumUser = persistence.loadIsPremiumUser()
        self.exportCount = persistence.loadExportCount()
        self.projects = persistence.loadProjects()

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

struct VideoProject: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var videoURL: URL?
    var captions: [Caption] = []
    var effects: [VideoEffect] = []
    var createdAt = Date()
}

struct Caption: Identifiable, Codable {
    var id: UUID = UUID()
    var text: String
    var startTime: Double
    var endTime: Double
    var style: CaptionStyle = .viral
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
    var id: UUID = UUID()
    var name: String
    var type: EffectType
    var intensity: Double = 1.0
}

enum EffectType: String, CaseIterable, Codable {
    case transition = "Transition"
    case filter = "Filter"
    case overlay = "Overlay"
    case animation = "Animation"
}
