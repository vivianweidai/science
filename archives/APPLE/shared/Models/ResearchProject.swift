import Foundation

public struct ResearchProject: Identifiable, Hashable, Sendable {
    public var id: String { folder }
    public let folder: String        // "20250315 FTIR Polymer Study"
    public let date: String
    public let title: String
    public let indexURL: URL         // GitHub raw URL to the project's index.md
    public let subject: String?      // "Chemistry", "Biology", etc. — parsed from research/index.md

    public init(folder: String, date: String, title: String, indexURL: URL, subject: String? = nil) {
        self.folder = folder
        self.date = date
        self.title = title
        self.indexURL = indexURL
        self.subject = subject
    }
}
