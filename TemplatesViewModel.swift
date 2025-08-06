import Foundation
#if canImport(Combine)
import Combine
#endif

class TemplatesViewModel: ObservableObject {
    @Published var selectedCategory: TemplateCategory = .trending
    @Published var templates: [Template]
    @Published var trendingTracks: [TrendingTrack] = []

    private let trendService: TrendService

    init(
        templates: [Template] = [
        Template(name: "Viral Hook", category: .trending, thumbnail: "play.rectangle.fill"),
        Template(name: "Storytime", category: .trending, thumbnail: "text.bubble.fill"),
        Template(name: "Tutorial", category: .educational, thumbnail: "graduationcap.fill"),
        Template(name: "Product Review", category: .business, thumbnail: "star.fill"),
        Template(name: "GRWM", category: .lifestyle, thumbnail: "person.fill"),
        Template(name: "Recipe", category: .lifestyle, thumbnail: "fork.knife")
    ],
        trendService: TrendService = TrendService()
    ) {
        self.templates = templates
        self.trendService = trendService
    }

    var filteredTemplates: [Template] {
        templates.filter { $0.category == selectedCategory }
    }

    func fetchTemplates() {
        // Placeholder for API call to fetch templates
    }

    @MainActor
    func fetchTrendingAudio() async {
        do {
            trendingTracks = try await trendService.fetchTrendingTracks()
        } catch {
            print("⚠️ Failed to fetch trending tracks: \(error)")
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
