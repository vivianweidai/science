import Foundation

/// One flashcard file under /curriculum/{subject}/{section}/{table}.md.
/// The body is raw markdown — KaTeX rendering happens in MarkdownWebView.
public struct NoteCard: Identifiable, Hashable, Codable, Sendable {
    public var id: String { "\(subject)/\(section)/\(table)" }
    public let subject: String
    public let section: String
    public let topic: String
    public let table: String
    public let order: Int
    public let path: String      // repo-relative, e.g. curriculum/mathematics/algebra/vieta.md
    public let body: String      // full file contents minus front matter

    public init(subject: String, section: String, topic: String, table: String,
                order: Int, path: String, body: String) {
        self.subject = subject
        self.section = section
        self.topic = topic
        self.table = table
        self.order = order
        self.path = path
        self.body = body
    }
}
