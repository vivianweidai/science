import Foundation

public struct Olympiad: Identifiable, Hashable, Codable, Sendable {
    public let id: Int
    public let subject: String
    public let date: String
    public let sortKey: String
    public let country: String
    public let name: String
    public let finished: Int
    public let highlighted: Int

    enum CodingKeys: String, CodingKey {
        case id, subject, date, country, name, finished, highlighted
        case sortKey = "sort_key"
    }
}

public struct OlympiadList: Codable, Sendable {
    public let items: [Olympiad]
}
