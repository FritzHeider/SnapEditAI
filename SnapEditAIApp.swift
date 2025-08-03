#if canImport(SwiftUI)
import SwiftUI
#if canImport(FirebaseCore)
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
#endif
import Combine

@main
struct SnapEditAIApp: App {
    @StateObject private var appState = AppState()

    init() {
        AnalyticsManager.shared.setup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

class AppState: ObservableObject {
    @Published var isOnboardingComplete = false {
        didSet {
            if isOnboardingComplete && oldValue == false {
                AnalyticsManager.shared.logOnboardingCompleted()
            }
        }
    }

    @Published private(set) var isPremiumUser = false {
        didSet {
            AnalyticsManager.shared.setSubscriptionStatus(isPremium: isPremiumUser)
            if isPremiumUser && oldValue == false {
                AnalyticsManager.shared.logUpgrade()
            }
        }
    }

    @Published var currentProject: VideoProject?
    @Published var exportCount = 0 {
        didSet {
            AnalyticsManager.shared.setExportCount(exportCount)
        }
    }

    let subscriptionManager = SubscriptionManager.shared
    private var cancellables = Set<AnyCancellable>()
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

        AnalyticsManager.shared.setSubscriptionStatus(isPremium: isPremiumUser)
        AnalyticsManager.shared.setExportCount(exportCount)

        subscriptionManager.$isPremiumUser
            .receive(on: DispatchQueue.main)
            .assign(to: \AppState.isPremiumUser, on: self)
            .store(in: &cancellables)
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
        case .viral: return "\u{1F525}"
        case .minimal: return "\u{2728}"
        case .podcast: return "\u{1F399}\u{FE0F}"
        case .storytime: return "\u{1F4D6}"
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

#endif
