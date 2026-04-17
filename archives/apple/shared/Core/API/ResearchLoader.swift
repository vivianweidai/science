import Foundation

/// Lists research project folders under /research/projects/ by querying the
/// GitHub contents API, then decorates each entry with the subject parsed
/// from the HTML chips in /research/index.md.
///
/// Note: projects used to live directly under /research/, but that folder
/// now also holds `archives/` (reference PDFs and instrument manuals) and
/// `index.md` (the Jekyll landing page). The loader targets the
/// `research/projects/` subfolder so only real project directories are
/// enumerated.
///
/// Subject mapping: the authoritative source is the HTML chip markup inside
/// research/index.md — e.g. `<span class="chip chem">Chemistry</span>` next
/// to each `<a href="projects/20260411%20Centrifuge/">...`. We fetch that
/// file once per load and extract the (folder → subject) map with regex so
/// new projects added to the webapp automatically appear in iOS without an
/// app update.
public actor ResearchLoader {
    public static let shared = ResearchLoader()

    private static let owner = "vivianweidai"
    private static let repo = "science"
    private static let branch = "main"
    private static let projectsPath = "research/projects"

    private static let indexMdURL = URL(
        string: "https://raw.githubusercontent.com/\(owner)/\(repo)/\(branch)/research/index.md"
    )!

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func projects() async throws -> [ResearchProject] {
        async let entriesTask = fetchProjectEntries()
        async let subjectMapTask = fetchSubjectMap()

        let (entries, subjectMap) = try await (entriesTask, subjectMapTask)

        return entries.compactMap { entry in
            guard entry.type == "dir" else { return nil }
            let parts = entry.name.split(separator: " ", maxSplits: 1).map(String.init)
            guard parts.count == 2 else { return nil }
            let (date, title) = (parts[0], parts[1])
            guard let encodedPath = entry.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                  let indexURL = URL(string: "https://raw.githubusercontent.com/\(Self.owner)/\(Self.repo)/\(Self.branch)/\(encodedPath)/index.md") else {
                return nil
            }
            return ResearchProject(
                folder: entry.name,
                date: date,
                title: title,
                indexURL: indexURL,
                subject: subjectMap[entry.name]
            )
        }
        .sorted { $0.date > $1.date }
    }

    // MARK: - Contents API

    private func fetchProjectEntries() async throws -> [GitHubEntry] {
        guard let url = URL(string: "https://api.github.com/repos/\(Self.owner)/\(Self.repo)/contents/\(Self.projectsPath)?ref=\(Self.branch)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "accept")
        let (data, response) = try await session.data(for: request)
        try Self.checkHTTP(response)
        return try JSONDecoder().decode([GitHubEntry].self, from: data)
    }

    // MARK: - Subject map

    /// Extract (folder → subject) by scanning research/index.md for webapp
    /// chip markup. We look for `chip {slug}">{Name}` paired with a nearby
    /// `projects/{FOLDER}/` href within the same entry block.
    ///
    /// If the fetch or parse fails, returns an empty map — callers treat
    /// missing subjects as `nil` and simply render without the pill.
    private func fetchSubjectMap() async throws -> [String: String] {
        do {
            let (data, response) = try await session.data(from: Self.indexMdURL)
            try Self.checkHTTP(response)
            guard let html = String(data: data, encoding: .utf8) else { return [:] }
            return Self.parseSubjectMap(html: html)
        } catch {
            // Subject metadata is best-effort; don't fail the whole load.
            return [:]
        }
    }

    /// Parse the research/index.md HTML for project→subject pairs.
    /// Exposed `static` so unit-testable without an actor hop.
    static func parseSubjectMap(html: String) -> [String: String] {
        // Split on each <div class="entry ...> boundary. Each segment
        // contains a chip and a projects/ href that belong together.
        let entries = html.components(separatedBy: "<div class=\"entry")
        var map: [String: String] = [:]

        // Pre-compile the chip and href patterns.
        let chipRegex = try? NSRegularExpression(
            pattern: #"<span class="chip (\w+)">([^<]+)</span>"#,
            options: []
        )
        let hrefRegex = try? NSRegularExpression(
            pattern: #"projects/([^/"]+)/"#,
            options: []
        )

        guard let chipRegex, let hrefRegex else { return map }

        for segment in entries.dropFirst() {
            let ns = segment as NSString
            let range = NSRange(location: 0, length: ns.length)

            guard let chipMatch = chipRegex.firstMatch(in: segment, range: range),
                  let hrefMatch = hrefRegex.firstMatch(in: segment, range: range) else {
                continue
            }

            let subjectName = ns.substring(with: chipMatch.range(at: 2))
            let encodedFolder = ns.substring(with: hrefMatch.range(at: 1))
            let folder = encodedFolder.removingPercentEncoding ?? encodedFolder
            map[folder] = subjectName
        }

        return map
    }

    private static func checkHTTP(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
