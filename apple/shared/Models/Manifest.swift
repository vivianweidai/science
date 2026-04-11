import Foundation

/// Lightweight directory listing returned by GitHub's contents API.
struct GitHubEntry: Decodable {
    let name: String
    let path: String
    let type: String     // "file" or "dir"
    let downloadURL: URL?

    enum CodingKeys: String, CodingKey {
        case name, path, type
        case downloadURL = "download_url"
    }
}
