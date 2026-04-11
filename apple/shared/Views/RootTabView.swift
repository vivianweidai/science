import SwiftUI

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
