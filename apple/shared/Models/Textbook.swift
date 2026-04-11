import Foundation

public struct Textbook: Identifiable, Hashable, Codable, Sendable {
    public let id: Int
    public let subject: String
    public let date: String
    public let sortKey: String
    public let title: String
    public let finished: Int
    public let highlighted: Int

    enum CodingKeys: String, CodingKey {
        case id, subject, date, title, finished, highlighted
        case sortKey = "sort_key"
    }
}

public struct TextbookList: Codable, Sendable {
    public let items: [Textbook]
}
