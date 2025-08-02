import Foundation
import SwiftUI

class AppState: ObservableObject, Codable {
    @Published var isOnboardingComplete = false
    @Published var isPremiumUser = false
    @Published var currentProject: VideoProject?
    @Published var exportCount = 0

    enum CodingKeys: String, CodingKey {
        case isOnboardingComplete
        case isPremiumUser
        case currentProject
        case exportCount
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isOnboardingComplete = try container.decode(Bool.self, forKey: .isOnboardingComplete)
        isPremiumUser = try container.decode(Bool.self, forKey: .isPremiumUser)
        currentProject = try container.decodeIfPresent(VideoProject.self, forKey: .currentProject)
        exportCount = try container.decode(Int.self, forKey: .exportCount)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isOnboardingComplete, forKey: .isOnboardingComplete)
        try container.encode(isPremiumUser, forKey: .isPremiumUser)
        try container.encodeIfPresent(currentProject, forKey: .currentProject)
        try container.encode(exportCount, forKey: .exportCount)
    }

    let maxFreeExports = 3

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
    let id: UUID = UUID()
    var title: String
    var videoURL: URL?
    var captions: [Caption] = []
    var effects: [VideoEffect] = []
    var createdAt: Date = Date()
}

struct Caption: Identifiable, Codable {
    let id: UUID = UUID()
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
    let id: UUID = UUID()
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
