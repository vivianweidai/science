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
                            projectRow(project)
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

    /// Project title + date with a subject chip trailing the title (matches
    /// the webapp chip markup at `<span class="chip {slug}">{Subject}</span>`
    /// in research/index.md).
    @ViewBuilder
    private func projectRow(_ project: ResearchProject) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(project.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                if let subject = project.subject {
                    SubjectChip(subject: subject)
                }
            }
            Text(project.date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

/// Small subject chip matching the webapp .chip style — a rounded capsule
/// with the canonical subject color. Defined at file scope so this view can
/// use it without exposing OlympiadsView's private chip type.
private struct SubjectChip: View {
    let subject: String

    var body: some View {
        Text(subject)
            .font(.system(size: 10, weight: .semibold))
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(Capsule().fill(SubjectPalette.color(for: subject)))
            .foregroundStyle(Color.black.opacity(0.82))
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
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            do {
                let (data, _) = try await URLSession.shared.data(from: project.indexURL)
                var md = String(data: data, encoding: .utf8) ?? ""
                let photos = MarkdownHelper.extractPhotos(from: md)
                md = MarkdownHelper.stripFrontMatter(md)
                md = MarkdownHelper.injectPhotos(md, photos: photos)
                md = MarkdownHelper.stripJekyllSyntax(md)
                // Relative paths in the project's index.md resolve against
                // the folder that contains index.md — derive that URL rather
                // than hardcoding the repo layout in MarkdownHelper.
                let folderURL = project.indexURL.deletingLastPathComponent()
                md = MarkdownHelper.resolveRelativeURLs(in: md, baseURL: folderURL)
                markdown = md
            } catch {
                markdown = "# Error\n\n\(error.localizedDescription)"
            }
            loading = false
        }
    }

}
