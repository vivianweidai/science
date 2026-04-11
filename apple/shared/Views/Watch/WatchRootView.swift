#if os(watchOS)
import SwiftUI

/// Root view for the Apple Watch companion app.
///
/// Watch screens share the ScienceCore Models + API with iPhone/iPad but
/// use a stripped-down UI: plain SwiftUI lists, no WKWebView-backed KaTeX
/// rendering (watchOS has no WebKit). Markdown bodies are shown as plain
/// text with LaTeX left as-is — still useful as a quick reference on the
/// wrist.
public struct WatchRootView: View {
    public init() {}

    public var body: some View {
        TabView {
            WatchCurriculumView()
            WatchOlympiadsView()
            WatchResearchView()
        }
    }
}
#endif
