import XCTest
@testable import SnapEditAI

final class TrendServiceTests: XCTestCase {
    func testFetchTrendingTracksReturnsResults() async throws {
        let sample = """
        {"feed":{"results":[{"name":"Song1","artistName":"Artist1"},{"name":"Song2","artistName":"Artist2"},{"name":"Song3","artistName":"Artist3"}]}}
        """.data(using: .utf8)!

        let service = TrendService(overrideData: sample)
        let tracks = try await service.fetchTrendingTracks(limit: 3)
        XCTAssertEqual(tracks.count, 3)
        XCTAssertEqual(tracks.first?.title, "Song1")
    }
}
