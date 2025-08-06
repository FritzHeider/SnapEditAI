import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct TrendingTrack: Equatable, Decodable {
    let title: String
    let artist: String
    let previewURL: URL?
}

struct TrendService {
    let session: URLSession
    let overrideData: Data?

    init(session: URLSession = .shared, overrideData: Data? = nil) {
        self.session = session
        self.overrideData = overrideData
    }

    func fetchTrendingTracks(limit: Int = 10) async throws -> [TrendingTrack] {
        let data: Data
        if let overrideData {
            data = overrideData
        } else {
            let url = URL(string: "https://itunes.apple.com/us/rss/topsongs/limit=\(limit)/json")!
            let (fetchedData, _) = try await session.data(from: url)
            data = fetchedData
        }
        let feed = try JSONDecoder().decode(ITunesFeed.self, from: data)
        return feed.feed.results.map { result in
            TrendingTrack(
                title: result.name,
                artist: result.artistName,
                previewURL: URL(string: result.previewUrl ?? "")
            )
        }
    }

    private struct ITunesFeed: Decodable {
        let feed: Feed

        struct Feed: Decodable {
            let results: [Result]
        }

        struct Result: Decodable {
            let name: String
            let artistName: String
            let previewUrl: String?
        }
    }
}
