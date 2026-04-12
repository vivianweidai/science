import Foundation

/// Markdown processing utilities for transforming GitHub-hosted project
/// pages into content suitable for the iOS WKWebView renderer.
enum MarkdownHelper {

    // MARK: - Cached regex patterns

    private static let mdImageRegex = try! NSRegularExpression(pattern: #"(\!\[[^\]]*\]\()(?!https?://)([^\)]+)(\))"#)
    private static let htmlImgRegex = try! NSRegularExpression(pattern: #"(<img\s[^>]*src=")(?!https?://)([^"]+)(")"#)
    private static let scriptRegex = try! NSRegularExpression(pattern: #"<script[\s\S]*?</script>"#)

    // MARK: - Front matter

    /// Strip YAML front matter (--- ... ---) from the top of markdown.
    static func stripFrontMatter(_ md: String) -> String {
        let trimmed = md.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("---") else { return md }
        let afterFirst = trimmed.dropFirst(3)
        guard let endRange = afterFirst.range(of: "\n---") else { return md }
        let afterFrontMatter = afterFirst[endRange.upperBound...]
        return String(afterFrontMatter).trimmingCharacters(in: .newlines)
    }

    /// Extract photo paths from YAML front matter.
    static func extractPhotos(from md: String) -> [String] {
        let trimmed = md.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("---") else { return [] }
        let afterFirst = trimmed.dropFirst(3)
        guard let endRange = afterFirst.range(of: "\n---") else { return [] }
        let frontMatter = String(afterFirst[..<endRange.lowerBound])
        var photos: [String] = []
        var inPhotos = false
        for line in frontMatter.components(separatedBy: "\n") {
            let t = line.trimmingCharacters(in: .whitespaces)
            if t.hasPrefix("photos:") || t.hasPrefix("data_photos:") { inPhotos = true; continue }
            if inPhotos {
                if t.hasPrefix("- ") {
                    photos.append(String(t.dropFirst(2)))
                } else {
                    inPhotos = false
                }
            }
        }
        return photos
    }

    // MARK: - Photo injection

    /// Replace empty photo-grid img tags with actual src from front matter.
    static func injectPhotos(_ md: String, photos: [String]) -> String {
        guard !photos.isEmpty else { return md }
        var result = md
        for (i, photo) in photos.prefix(4).enumerated() {
            let pattern = "<img id=\"photo-\(i)\" alt=\"Experiment photo\">"
            let replacement = "<img id=\"photo-\(i)\" src=\"\(photo)\" alt=\"Experiment photo\">"
            result = result.replacingOccurrences(of: pattern, with: replacement)
        }
        return result
    }

    // MARK: - Jekyll cleanup

    /// Remove Jekyll/Liquid template syntax that won't render in the app.
    static func stripJekyllSyntax(_ md: String) -> String {
        var result = md
        let ns = result as NSString
        result = scriptRegex.stringByReplacingMatches(
            in: result,
            range: NSRange(location: 0, length: ns.length),
            withTemplate: ""
        )
        result = result.components(separatedBy: "\n")
            .filter { !$0.contains("{{") && !$0.contains("{%") }
            .joined(separator: "\n")
        return result
    }

    // MARK: - URL resolution

    /// Rewrite relative image/link paths to absolute GitHub raw URLs.
    static func resolveRelativeURLs(in markdown: String, folder: String) -> String {
        let encoded = folder.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? folder
        let base = "https://raw.githubusercontent.com/vivianweidai/science/main/research/\(encoded)/"

        var result = markdown

        // Markdown images: ![alt](relative)
        result = replaceRelativePaths(in: result, regex: mdImageRegex, base: base, group: 2)

        // HTML images: <img src="relative">
        result = replaceRelativePaths(in: result, regex: htmlImgRegex, base: base, group: 2)

        return result
    }

    private static func replaceRelativePaths(in text: String, regex: NSRegularExpression, base: String, group: Int) -> String {
        var result = text
        let ns = result as NSString
        let matches = regex.matches(in: result, range: NSRange(location: 0, length: ns.length))
        for match in matches.reversed() {
            let path = ns.substring(with: match.range(at: group))
            let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? path
            var full = ""
            for i in 1...match.numberOfRanges - 1 {
                if i == group {
                    full += base + encodedPath
                } else {
                    full += ns.substring(with: match.range(at: i))
                }
            }
            result = (result as NSString).replacingCharacters(in: match.range, with: full)
        }
        return result
    }
}
