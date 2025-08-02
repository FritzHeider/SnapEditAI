import Foundation
#if canImport(Combine)
import Combine
#endif

class TemplatesViewModel: ObservableObject {
    @Published var selectedCategory: TemplateCategory = .trending
    @Published var templates: [Template]

    init(templates: [Template] = [
        Template(name: "Viral Hook", category: .trending, thumbnail: "play.rectangle.fill"),
        Template(name: "Storytime", category: .trending, thumbnail: "text.bubble.fill"),
        Template(name: "Tutorial", category: .educational, thumbnail: "graduationcap.fill"),
        Template(name: "Product Review", category: .business, thumbnail: "star.fill"),
        Template(name: "GRWM", category: .lifestyle, thumbnail: "person.fill"),
        Template(name: "Recipe", category: .lifestyle, thumbnail: "fork.knife")
    ]) {
        self.templates = templates
    }

    var filteredTemplates: [Template] {
        templates.filter { $0.category == selectedCategory }
    }

    func fetchTemplates() {
        // Placeholder for API call to fetch templates
    }
}
