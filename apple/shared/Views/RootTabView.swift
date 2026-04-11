#if os(iOS)
import SwiftUI

/// Root view for iPhone and iPad.
///
/// On iPhone (compact width) this is a standard bottom TabView. On iPad
/// (regular width) SwiftUI will automatically present the same TabView —
/// the individual screens already use `NavigationStack` which adapts to
/// the wider canvas. Future enhancement: switch to `NavigationSplitView`
/// on regular width for a sidebar layout.
public struct RootTabView: View {
    public init() {}

    public var body: some View {
        TabView {
            CurriculumView()
                .tabItem { Label("Curriculum", systemImage: "book") }
            OlympiadsView()
                .tabItem { Label("Olympiads", systemImage: "trophy") }
            ResearchView()
                .tabItem { Label("Research", systemImage: "flask") }
        }
    }
}
#endif
