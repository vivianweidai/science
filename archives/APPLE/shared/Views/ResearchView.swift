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

    /// Project title on top, with the formatted date and subject chip
    /// sharing the second line. Subject mapping comes from the webapp
    /// chip markup in research/index.md.
    @ViewBuilder
    private func projectRow(_ project: ResearchProject) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(project.title)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(formatProjectDate(project.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let subject = project.subject {
                    SubjectChip(subject: subject)
                }
            }
        }
    }

    /// Convert the raw `YYYYMMDD` folder-date prefix into a readable
    /// `Month Day{st,nd,rd,th} Year` string (e.g. "April 4th 2026").
    /// Falls back to the raw string if parsing fails so nothing ever
    /// disappears from the UI.
    private func formatProjectDate(_ raw: String) -> String {
        guard raw.count == 8,
              let year = Int(raw.prefix(4)),
              let month = Int(raw.dropFirst(4).prefix(2)),
              let day = Int(raw.suffix(2)),
              (1...12).contains(month) else {
            return raw
        }
        let monthNames = [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December",
        ]
        return "\(monthNames[month - 1]) \(day)\(ordinalSuffix(for: day)) \(year)"
    }

    /// English ordinal suffix: 1st, 2nd, 3rd, 4th … with the 11/12/13
    /// exception (11th, 12th, 13th — not 11st, 12nd, 13rd).
    private func ordinalSuffix(for day: Int) -> String {
        let lastTwo = day % 100
        if (11...13).contains(lastTwo) { return "th" }
        switch day % 10 {
        case 1:  return "st"
        case 2:  return "nd"
        case 3:  return "rd"
        default: return "th"
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
