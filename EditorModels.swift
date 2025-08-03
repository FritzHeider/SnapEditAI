import Foundation

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
