import Foundation

/// Read-only client for activity listings (olympiads + textbooks).
///
/// The source of truth is archives/truth/olympiads.yml. A Python build
/// script generates archives/truth/olympiads.json which we fetch directly
/// from GitHub's raw content host. No database, no API layer, no writes.
public actor APIClient {
    public static let shared = APIClient()

    public static let baseURL = URL(
        string: "https://raw.githubusercontent.com/vivianweidai/science/main/archives/truth"
    )!

    private let session: URLSession
    private let decoder: JSONDecoder
    private var cachedActivities: [Activity]?
    private var cachedTopics: [ResearchTopic]?

    public init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    /// Return cached activities if a previous fetch (e.g. the
    /// app-launch preload) already populated them; otherwise fetch.
    /// Caching here is what makes the background preload useful — when
    /// the user taps the Olympiads tab, its `.task` returns the
    /// already-loaded list instantly.
    public func listActivities() async throws -> [Activity] {
        if let cachedActivities { return cachedActivities }
        let items = try await get(file: "olympiads.json", as: ActivityList.self).items
        cachedActivities = items
        return items
    }

    public func listResearchTopics() async throws -> [ResearchTopic] {
        if let cachedTopics { return cachedTopics }
        let topics = try await get(file: "toys.json", as: ResearchToysResponse.self).topics
        cachedTopics = topics
        return topics
    }

    /// Invalidate caches — wired to pull-to-refresh so users can force
    /// a round trip when they've just pushed new YAML.
    public func invalidate() {
        cachedActivities = nil
        cachedTopics = nil
    }

    // MARK: - Private

    private func get<T: Decodable>(file: String, as: T.Type) async throws -> T {
        let url = Self.baseURL.appending(path: file)
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadRevalidatingCacheData
        let (data, response) = try await session.data(for: request)
        try Self.check(response)
        return try decoder.decode(T.self, from: data)
    }

    private static func check(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
