import Foundation

/// Thin client for the Cloudflare Pages Function that backs olympiads/textbooks.
/// Reads are public; writes assume the user has authenticated via Cloudflare
/// Access (the browser/session cookie is sent automatically by URLSession when
/// the app is opened after signing in through a WKWebView).
public actor APIClient {
    public static let shared = APIClient()

    public static let baseURL = URL(string: "https://vivianweidai.com/api")!

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    public func listOlympiads() async throws -> [Olympiad] {
        try await get(path: "olympiads", as: OlympiadList.self).items
    }

    public func listTextbooks() async throws -> [Textbook] {
        try await get(path: "textbooks", as: TextbookList.self).items
    }

    public func setOlympiadFinished(id: Int, finished: Bool) async throws {
        try await patch(path: "olympiads/\(id)", body: ["finished": finished])
    }

    public func setTextbookFinished(id: Int, finished: Bool) async throws {
        try await patch(path: "textbooks/\(id)", body: ["finished": finished])
    }

    // MARK: - Private

    private func get<T: Decodable>(path: String, as: T.Type) async throws -> T {
        let url = Self.baseURL.appending(path: path)
        let (data, response) = try await session.data(from: url)
        try Self.check(response)
        return try decoder.decode(T.self, from: data)
    }

    private func patch(path: String, body: [String: Bool]) async throws {
        let url = Self.baseURL.appending(path: path)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (_, response) = try await session.data(for: request)
        try Self.check(response)
    }

    private static func check(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
