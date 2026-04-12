import Foundation

public struct Activity: Identifiable, Hashable, Codable, Sendable {
    public let id: Int
    public let type: String           // "olympiad" or "textbook"
    public let subject: String
    public let date: String
    public let sortKey: String
    public let name: String
    public let country: String?
    public let finished: Int
    public let highlighted: Int

    enum CodingKeys: String, CodingKey {
        case id, type, subject, date, name, country, finished, highlighted
        case sortKey = "sort_key"
    }

    public var isOlympiad: Bool { type == "olympiad" }
    public var isTextbook: Bool { type == "textbook" }
}

public struct ActivityList: Codable, Sendable {
    public let items: [Activity]
}
