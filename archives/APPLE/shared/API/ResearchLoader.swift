import Foundation

/// Lists research project folders under /research/ by querying the GitHub
/// contents API. Each folder is named `YYYYMMDD Project Name`.
public actor ResearchLoader {
    public static let shared = ResearchLoader()

    private static let owner = "vivianweidai"
    private static let repo = "science"
    private static let branch = "main"

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func projects() async throws -> [ResearchProject] {
        guard let url = URL(string: "https://api.github.com/repos/\(Self.owner)/\(Self.repo)/contents/research?ref=\(Self.branch)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "accept")
        let (data, response) = try await session.data(for: request)
        try Self.checkHTTP(response)
        let entries = try JSONDecoder().decode([GitHubEntry].self, from: data)

        return entries.compactMap { entry in
            guard entry.type == "dir" else { return nil }
            let parts = entry.name.split(separator: " ", maxSplits: 1).map(String.init)
            guard parts.count == 2 else { return nil }
            let (date, title) = (parts[0], parts[1])
            guard let encodedPath = entry.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                  let indexURL = URL(string: "https://raw.githubusercontent.com/\(Self.owner)/\(Self.repo)/\(Self.branch)/\(encodedPath)/index.md") else {
                return nil
            }
            return ResearchProject(folder: entry.name, date: date, title: title, indexURL: indexURL)
        }
        .sorted { $0.date > $1.date }
    }

    private static func checkHTTP(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
