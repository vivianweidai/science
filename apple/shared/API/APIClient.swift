import Foundation

/// Read-only client for olympiad and textbook listings.
///
/// The source of truth is YAML in the repo (content/olympiads.yml,
/// content/textbooks.yml). A Python build script generates static JSON files
/// (archives/olympiads.json, archives/textbooks.json) which we fetch directly
/// from GitHub's raw content host. No database, no API layer, no writes.
///
/// If we ever want a stabler URL (or to avoid raw.githubusercontent rate limits),
/// flip `baseURL` to "https://vivianweidai.com/archives" — the GitHub Pages
/// build serves the exact same files at that path.
public actor APIClient {
    public static let shared = APIClient()

    public static let baseURL = URL(
        string: "https://raw.githubusercontent.com/vivianweidai/science/main/archives"
    )!

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    public func listOlympiads() async throws -> [Olympiad] {
        try await get(file: "olympiads.json", as: OlympiadList.self).items
    }

    public func listTextbooks() async throws -> [Textbook] {
        try await get(file: "textbooks.json", as: TextbookList.self).items
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
