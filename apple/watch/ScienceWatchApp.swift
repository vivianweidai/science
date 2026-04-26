import SwiftUI

/// Entry point for the watchOS companion app.
///
/// The watch app is intentionally scoped to a single thing: the
/// unified olympiads + textbooks timeline. It shares data and
/// filter/grouping semantics with the iPhone app via `ScienceCore`,
/// but its UI is written from scratch to fit a watch screen instead
/// of shrinking the iPhone `OlympiadsView`.
@main
struct ScienceWatchApp: App {
    var body: some Scene {
        WindowGroup {
            OlympiadsRootView()
        }
    }
}
