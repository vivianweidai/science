import SwiftUI

struct ResearchView: View {
    @State private var projects: [ResearchProject] = []
    @State private var loading = true
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    ProgressView()
                } else if let error {
                    Text(error).foregroundStyle(.red).padding()
                } else {
                    List(projects) { project in
                        NavigationLink {
                            ProjectDetailView(project: project)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(project.title).font(.headline)
                                Text(project.date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Research")
            .task { await load() }
            .refreshable { await load() }
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

struct ProjectDetailView: View {
    let project: ResearchProject
    @State private var markdown: String = ""
    @State private var loading = true

    var body: some View {
        Group {
            if loading {
                ProgressView()
            } else {
                MarkdownWebView(markdown: markdown)
            }
        }
        .navigationTitle(project.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                let (data, _) = try await URLSession.shared.data(from: project.indexURL)
                var md = String(data: data, encoding: .utf8) ?? ""
                let photos = MarkdownHelper.extractPhotos(from: md)
                md = MarkdownHelper.stripFrontMatter(md)
                md = MarkdownHelper.injectPhotos(md, photos: photos)
                md = MarkdownHelper.stripJekyllSyntax(md)
                md = MarkdownHelper.resolveRelativeURLs(in: md, folder: project.folder)
                markdown = md
            } catch {
                markdown = "# Error\n\n\(error.localizedDescription)"
            }
            loading = false
        }
    }

}
