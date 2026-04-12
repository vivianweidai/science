import Foundation

/// Read-only client for activity listings (olympiads + textbooks).
///
/// The source of truth is archives/CONTENT/olympiads.yml. A Python build
/// script generates archives/CONTENT/olympiads.json which we fetch directly
/// from GitHub's raw content host. No database, no API layer, no writes.
public actor APIClient {
    public static let shared = APIClient()

    public static let baseURL = URL(
        string: "https://raw.githubusercontent.com/vivianweidai/science/main/archives/CONTENT"
    )!

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    public func listActivities() async throws -> [Activity] {
        try await get(file: "olympiads.json", as: ActivityList.self).items
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
