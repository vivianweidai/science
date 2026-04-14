import Foundation
import ScienceCore

/// On-disk cache of the last successful `olympiads.json` fetch.
///
/// The watch radio is slow and intermittently unavailable — a cold
/// launch that has to round-trip to GitHub before showing any content
/// takes 1–3 seconds during which the screen is just a spinner. This
/// helper writes every successful response to the app's Caches
/// directory so the next launch can render the old list on the first
/// frame, then silently swap in whatever the network returns.
///
/// Scoped to the watch target because iOS devices are essentially
/// always on good networks — adding a cache there would be premature.
/// If that changes, lift this file into `ScienceCore` unchanged.
enum ActivityCache {
    /// Filename used inside the Caches directory. The content is the
    /// same shape as the upstream JSON (`ActivityList`), not a custom
    /// format, so that re-decoding is trivial and a future migration
    /// that reads the cache straight into `APIClient` is still possible.
    private static let fileName = "olympiads_cache.json"

    private static var cacheURL: URL? {
        let fm = FileManager.default
        guard let dir = try? fm.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ) else { return nil }
        return dir.appendingPathComponent(fileName)
    }

    /// Reads the cached list synchronously. Returns `nil` if no cache
    /// exists, the file is unreadable, or decoding fails — all of
    /// which are handled identically by the call site (fall back to
    /// the spinner-then-network flow).
    static func load() -> [Activity]? {
        guard let url = cacheURL,
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(ActivityList.self, from: data)
        else { return nil }
        return decoded.items
    }

    /// Atomically replaces the cached payload. Silently swallows any
    /// write failure — the user-visible state is unchanged and the
    /// cache will be rewritten on the next successful fetch anyway.
    static func save(_ items: [Activity]) {
        guard let url = cacheURL else { return }
        let payload = ActivityList(items: items)
        guard let data = try? JSONEncoder().encode(payload) else { return }
        try? data.write(to: url, options: .atomic)
    }
}
