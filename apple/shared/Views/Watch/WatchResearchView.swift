#if os(watchOS)
import SwiftUI

/// Research project list for watchOS.
///
/// Tapping a project fetches the index.md and shows it as plain text.
struct WatchResearchView: View {
    @State private var projects: [ResearchProject] = []
    @State private var loading = true
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    ProgressView()
                } else if let error {
                    Text(error).foregroundStyle(.red).font(.caption)
                } else {
                    List(projects) { project in
                        NavigationLink {
                            WatchProjectDetailView(project: project)
                        } label: {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(project.title).font(.footnote)
                                Text(project.date)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Research")
            .task { await load() }
        }
    }

    private func load() async {
        loading = true
        do {
            projects = try await ResearchLoader.shared.projects()
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        loading = false
    }
}

struct WatchProjectDetailView: View {
    let project: ResearchProject
    @State private var markdown: String = ""
    @State private var loading = true

    var body: some View {
        Group {
            if loading {
                ProgressView()
            } else {
                ScrollView {
                    Text(markdown)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                }
            }
        }
        .navigationTitle(project.title)
        .task {
            do {
                let (data, _) = try await URLSession.shared.data(from: project.indexURL)
                markdown = String(data: data, encoding: .utf8) ?? ""
            } catch {
                markdown = "Error: \(error.localizedDescription)"
            }
            loading = false
        }
    }
}
#endif
