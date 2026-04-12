import Foundation

/// Loads curriculum flashcards from the GitHub repo by walking the
/// contents API. Results are cached in memory for the life of the app.
public actor NotesLoader {
    public static let shared = NotesLoader()

    private static let owner = "vivianweidai"
    private static let repo = "science"
    private static let branch = "main"

    private let session: URLSession
    private var cache: [String: [NoteCard]] = [:]

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func cards(forSubject subject: String) async throws -> [NoteCard] {
        if let cached = cache[subject] { return cached }
        let sections = try await listDir("curriculum/\(subject)")
        var all: [NoteCard] = []
        for section in sections where section.type == "dir" {
            let files = try await listDir(section.path)
            for file in files where file.type == "file" && file.name.hasSuffix(".md") {
                if let url = file.downloadURL {
                    let body = try await fetchText(url)
                    if let card = parseNote(path: file.path, raw: body) {
                        all.append(card)
                    }
                }
            }
        }
        all.sort { ($0.section, $0.order) < ($1.section, $1.order) }
        cache[subject] = all
        return all
    }

    /// Clear cached data so the next fetch pulls fresh content.
    public func invalidateCache(for subject: String? = nil) {
        if let subject { cache.removeValue(forKey: subject) }
        else { cache.removeAll() }
    }

    // MARK: - Private

    private func listDir(_ path: String) async throws -> [GitHubEntry] {
        guard let encoded = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "https://api.github.com/repos/\(Self.owner)/\(Self.repo)/contents/\(encoded)?ref=\(Self.branch)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "accept")
        let (data, response) = try await session.data(for: request)
        try Self.checkHTTP(response)
        return try JSONDecoder().decode([GitHubEntry].self, from: data)
    }

    private func fetchText(_ url: URL) async throws -> String {
        let (data, response) = try await session.data(from: url)
        try Self.checkHTTP(response)
        guard let text = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return text
    }

    private static func checkHTTP(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    private func parseNote(path: String, raw: String) -> NoteCard? {
        guard raw.hasPrefix("---") else { return nil }
        let afterFirst = raw.dropFirst(3)
        guard let closeRange = afterFirst.range(of: "\n---") else { return nil }
        let headerText = String(afterFirst[..<closeRange.lowerBound])
        let body = String(afterFirst[closeRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)

        var fields: [String: String] = [:]
        for line in headerText.split(separator: "\n") {
            let parts = line.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 { fields[parts[0]] = parts[1] }
        }

        guard let subject = fields["subject"],
              let section = fields["section"],
              let topic = fields["topic"],
              let table = fields["table"] else { return nil }
        let order = Int(fields["order"] ?? "0") ?? 0
        return NoteCard(
            subject: subject,
            section: section,
            topic: topic,
            table: table,
            order: order,
            path: path,
            body: body
        )
    }
}
