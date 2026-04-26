import Foundation

/// Strongly-typed mirror of `archives/truth/toys.json`, the source of
/// truth for the Research page's toy browser.
public struct ResearchTopic: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let science: String
    public let scienceSlug: String
    public let topic: String
    public let description: String?
    public let technologies: [ResearchTechnology]

    enum CodingKeys: String, CodingKey {
        case id, science, topic, description, technologies
        case scienceSlug = "science_slug"
    }
}

public struct ResearchTechnology: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let technology: String
    public let description: String?
    public let toys: [ResearchToy]
}

public struct ResearchToy: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let toy: String
    public let specs: String?
    public let available: Int?
    public let url: String?
    public let projectUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, toy, specs, available, url
        case projectUrl = "project_url"
    }

    public var isAvailable: Bool { (available ?? 0) == 1 }

    /// Raw GitHub URL for the project's `index.md`, when the toy points
    /// to an in-repo research project (e.g. `project_url` =
    /// `/research/projects/20250225%20Catfood/`). Returns `nil` if the
    /// toy has no project link. Used to render the project in-app via
    /// `MarkdownWebView` instead of bouncing to Safari.
    public var projectIndexURL: URL? {
        guard let path = projectUrl else { return nil }
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let withIndex = trimmed.hasSuffix("/") ? trimmed + "index.md" : trimmed + "/index.md"
        return URL(string: "https://raw.githubusercontent.com/vivianweidai/science/main/" + withIndex)
    }

    /// External URL to open in Safari (Wolfram, GitHub, Colab) — or
    /// resolved to a raw.githubusercontent URL when `url` is a
    /// repo-relative path like `/research/archives/photos/foo.jpg`,
    /// which is how toys.json stores placeholder image links.
    /// AsyncImage can't fetch a schemeless path, so the resolution
    /// must happen here rather than at render time.
    public var externalURL: URL? {
        guard let raw = url else { return nil }
        if raw.hasPrefix("http://") || raw.hasPrefix("https://") {
            return URL(string: raw)
        }
        let trimmed = raw.hasPrefix("/") ? String(raw.dropFirst()) : raw
        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? trimmed
        return URL(string: "https://raw.githubusercontent.com/vivianweidai/science/main/" + encoded)
    }
}

public struct ResearchToysResponse: Codable, Sendable {
    public let topics: [ResearchTopic]
}
