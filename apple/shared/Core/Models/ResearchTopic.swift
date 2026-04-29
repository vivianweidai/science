import Foundation

/// Strongly-typed mirror of `public/research/toys.json`, the source of
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
    public let hero: String?
    public let toyUrl: String?
    public let projects: [ResearchToyProject]?

    enum CodingKeys: String, CodingKey {
        case id, toy, specs, available, url, hero, projects
        case toyUrl = "toy_url"
    }

    /// Absolute URL for the toy's hero image. Resolves relative paths
    /// (the common case — frontmatter `hero: numpy.jpeg` is rewritten by
    /// `build_toys.py` to `/research/toys/<sci>/<toy>/numpy.jpeg`)
    /// against the site origin.
    public var heroURL: URL? {
        guard let hero else { return nil }
        if hero.hasPrefix("http://") || hero.hasPrefix("https://") {
            return URL(string: hero)
        }
        let trimmed = hero.hasPrefix("/") ? String(hero.dropFirst()) : hero
        return URL(string: "https://vivianweidai.com/" + trimmed)
    }

    public var isAvailable: Bool { (available ?? 0) == 1 }

    /// Raw URL for the toy page's `index.md` — what the iOS toy tap
    /// renders. Toy pages live at `/research/toys/<science>/<toy>/`
    /// and carry the toy-specific equipment/results/specs body. Replaces
    /// the project-page routing that pre-dated the toy-pages refactor.
    public var toyIndexURL: URL? {
        guard let path = toyUrl else { return nil }
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let encoded = trimmed.split(separator: "/").map {
            String($0).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? String($0)
        }.joined(separator: "/")
        let withIndex = encoded.hasSuffix("/") ? encoded + "index.md" : encoded + "/index.md"
        return URL(string: "https://vivianweidai.com/" + withIndex)
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
        return URL(string: "https://vivianweidai.com/" + encoded)
    }
}

public struct ResearchToysResponse: Codable, Sendable {
    public let topics: [ResearchTopic]
}

/// Per-toy project entry — combines the reverse-scanned local projects
/// (whose frontmatter `toys:` array references this toy) with the toy's
/// own `extra_projects:` placeholder list. Baked into `toys.json` by
/// `build_toys.py` so iOS/Android can render the toy detail view
/// without re-scanning every project at runtime.
public struct ResearchToyProject: Codable, Hashable, Sendable, Identifiable {
    public let date: String           // YYYY-MM-DD
    public let title: String
    public let url: String
    public let sciences: [String]
    public let folder: String?         // nil for `extra_projects` placeholders

    public var id: String { url }

    /// URL of the project's `index.md` for in-app rendering, when this
    /// is a local in-repo project (`folder` is set). Returns nil for
    /// placeholders — those route through `externalURL` instead.
    public var indexURL: URL? {
        guard folder != nil else { return nil }
        let trimmed = url.hasPrefix("/") ? String(url.dropFirst()) : url
        let withIndex = trimmed.hasSuffix("/") ? trimmed + "index.md" : trimmed + "/index.md"
        return URL(string: "https://vivianweidai.com/" + withIndex)
    }

    /// External URL when the project entry points off-repo (placeholders
    /// from `extra_projects`). Returns nil for local projects.
    public var externalURL: URL? {
        guard folder == nil else { return nil }
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            return URL(string: url)
        }
        return nil
    }
}
