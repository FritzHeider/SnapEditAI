import Foundation

final class AIService {
    static let shared = AIService()
    private init() {}

    private let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
    private let jsonDecoder = JSONDecoder()

    func generateCaptions(for videoURL: URL, style: CaptionStyle) async throws -> [Caption] {
        let transcript = try await transcribe(videoURL: videoURL)
        let prompt = """
        Split the following transcript into timestamped captions as a JSON array with fields text,start,end:
        \(transcript)
        """
        let message = try await chat(prompt: prompt)
        let data = Data(message.utf8)
        struct Segment: Decodable { let text: String; let start: Double; let end: Double }
        let segments = try jsonDecoder.decode([Segment].self, from: data)
        return segments.map { Caption(text: $0.text, startTime: $0.start, endTime: $0.end, style: style) }
    }

    private func transcribe(videoURL: URL) async throws -> String {
        guard !apiKey.isEmpty else { throw AIServiceError.missingAPIKey }
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/audio/transcriptions")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let audioData = try Data(contentsOf: videoURL)
        let boundary = UUID().uuidString
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n")
        body.append("Content-Type: audio/m4a\r\n\r\n")
        body.append(audioData)
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        body.append("whisper-1")
        body.append("\r\n--\(boundary)--\r\n")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        let (data, _) = try await URLSession.shared.data(for: request)
        struct WhisperResponse: Decodable { let text: String }
        let response = try jsonDecoder.decode(WhisperResponse.self, from: data)
        return response.text
    }

    private func chat(prompt: String) async throws -> String {
        guard !apiKey.isEmpty else { throw AIServiceError.missingAPIKey }
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ChatRequest(model: "gpt-4o-mini", messages: [ .init(role: "user", content: prompt) ])
        request.httpBody = try JSONEncoder().encode(body)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try jsonDecoder.decode(ChatResponse.self, from: data)
        return response.choices.first?.message.content ?? ""
    }

    func applyEffect(_ name: String, to project: VideoProject) async throws -> VideoEffect {
        _ = try await chat(prompt: "Create parameters for video effect \(name). Respond with JSON.")
        return VideoEffect(name: name, type: .animation)
    }

    func applyFilter(_ name: String, to project: VideoProject) async throws -> VideoEffect {
        _ = try await chat(prompt: "Create parameters for filter \(name). Respond with JSON.")
        return VideoEffect(name: name, type: .filter)
    }

    func enhanceAudio(_ enhancement: String, for project: VideoProject) async throws -> String {
        let message = try await chat(prompt: "Apply audio enhancement \(enhancement) and return status.")
        return message
    }

    struct ChatRequest: Encodable {
        let model: String
        let messages: [Message]
        struct Message: Encodable {
            let role: String
            let content: String
        }
    }

    struct ChatResponse: Decodable {
        let choices: [Choice]
        struct Choice: Decodable { let message: Message }
        struct Message: Decodable { let content: String }
    }

    enum AIServiceError: Error {
        case missingAPIKey
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
