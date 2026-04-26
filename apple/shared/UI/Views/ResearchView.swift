import SwiftUI
import ScienceCore

/// Toy browser matching the webapp /research/ page. Topics are grouped
/// cards with a subject chip, each containing rows of technologies and
/// their toys. Source of truth: content/research/toys.json.
struct ResearchView: View {
    @State private var store = ContentStore.shared
    @State private var subject: SubjectFilter = SubjectFilter.randomResearchSubject()
    /// Photo-placeholder toy currently being previewed. Presented as a
    /// modal sheet (slide-up) to match the in-project markdown image
    /// preview — the user explicitly preferred the sheet over the
    /// NavigationLink push, so both surfaces now use this pattern.
    @State private var presentedImage: IdentifiableURL?

    var body: some View {
        NavigationStack {
            Group {
                if let topics = store.topics {
                    content(topics: topics)
                } else if let errorMessage = store.topicsError {
                    ErrorState(message: errorMessage)
                } else {
                    LoadingState(
                        title: "Loading toys",
                        subtitle: "Fetching research topics from GitHub."
                    )
                }
            }
            .navigationTitle("Research")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    SubjectFilterMenu(selected: $subject)
                }
            }
            .refreshable { await store.refreshAll() }
            .sheet(item: $presentedImage) { wrapper in
                NavigationStack {
                    PhotoViewer(title: wrapper.url.lastPathComponent, url: wrapper.url)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button("Done") { presentedImage = nil }
                            }
                        }
                }
            }
        }
    }

    private func filteredTopics(_ topics: [ResearchTopic]) -> [ResearchTopic] {
        guard case .named(let name) = subject else { return topics }
        return topics.filter { $0.science == name }
    }

    private func content(topics: [ResearchTopic]) -> some View {
        let filtered = filteredTopics(topics)
        return ScrollView {
            LazyVStack(alignment: .leading, spacing: 14) {
                ForEach(filtered) { topic in
                    TopicCard(topic: topic) { url in presentedImage = IdentifiableURL(url: url) }
                }
                if filtered.isEmpty {
                    Text("No toys yet.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .italic()
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Topic card

private struct TopicCard: View {
    let topic: ResearchTopic
    let onImageTap: (URL) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider()
            VStack(alignment: .leading, spacing: 0) {
                ForEach(topic.technologies) { tech in
                    TechnologyBlock(tech: tech, onImageTap: onImageTap)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(ResearchColors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(SubjectPalette.color(for: topic.science).opacity(0.7), lineWidth: 1)
        )
        .overlay(alignment: .leading) {
            // Left accent bar, mirrors webapp .toys-accent-* border.
            RoundedRectangle(cornerRadius: 2)
                .fill(SubjectPalette.color(for: topic.science))
                .frame(width: 4)
        }
        .padding(.horizontal, 12)
    }

    private var header: some View {
        HStack(spacing: 6) {
            Text(topic.topic)
                .font(.system(size: 15, weight: .bold))
            SubjectChip(subject: topic.science)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.leading, 14)
        .padding(.trailing, 12)
    }
}

private struct TechnologyBlock: View {
    let tech: ResearchTechnology
    let onImageTap: (URL) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(tech.technology)
                .font(.system(size: 13, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 28, alignment: .leading)
                .padding(.leading, 14)
                .padding(.trailing, 12)
                .background(ResearchColors.technologyHeader)

            ForEach(tech.toys) { toy in
                ToyRow(toy: toy, onImageTap: onImageTap)
                if toy.id != tech.toys.last?.id {
                    Divider().padding(.leading, 28)
                }
            }
        }
    }
}

private struct ToyRow: View {
    let toy: ResearchToy
    let onImageTap: (URL) -> Void
    @Environment(\.openURL) private var openURL

    private var hasLink: Bool { toy.projectIndexURL != nil || toy.externalURL != nil }

    var body: some View {
        Group {
            if let projectURL = toy.projectIndexURL {
                NavigationLink {
                    ProjectDetailView(title: toy.toy, indexURL: projectURL)
                } label: {
                    rowBody
                }
                .buttonStyle(.plain)
            } else if let external = toy.externalURL, Self.isImageURL(external) {
                // Slide-up sheet (handled by ResearchView) instead of a
                // NavigationLink push — matches the in-project markdown
                // image preview so both surfaces feel the same.
                Button { onImageTap(external) } label: {
                    rowBody
                }
                .buttonStyle(.plain)
            } else if let external = toy.externalURL {
                Button { openURL(external) } label: {
                    rowBody
                }
                .buttonStyle(.plain)
            } else {
                rowBody
            }
        }
    }

    private static func isImageURL(_ url: URL) -> Bool {
        let lower = url.absoluteString.lowercased()
        return lower.hasSuffix(".jpg") || lower.hasSuffix(".jpeg")
            || lower.hasSuffix(".png") || lower.hasSuffix(".gif")
    }

    @ViewBuilder
    private var rowBody: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(toy.toy)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(hasLink ? Color.accentColor : Color.primary)
                    if let icon = ToyURLIcon.icon(for: toy) {
                        Text(icon).font(.system(size: 11))
                    }
                }
                if let specs = toy.specs, !specs.isEmpty {
                    Text(specs)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 0)
            if toy.isAvailable {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color(red: 0.10, green: 0.50, blue: 0.22))
            }
        }
        .padding(.vertical, 8)
        .padding(.leading, 28)
        .padding(.trailing, 12)
        .contentShape(Rectangle())
    }
}

/// Inline indicator next to a toy name, mirroring the webapp markup in
/// research/index.md. Tells the user at a glance that a link is a
/// placeholder photo, a notebook, etc. Returns `nil` when no url is set
/// or the url doesn't match a known pattern.
private enum ToyURLIcon {
    static func icon(for toy: ResearchToy) -> String? {
        guard let url = toy.url else { return nil }
        let lower = url.lowercased()
        if lower.hasSuffix(".jpg") || lower.hasSuffix(".jpeg")
            || lower.hasSuffix(".png") || lower.hasSuffix(".gif") {
            return "📷"
        }
        if toy.toy == "Jupyter" || lower.contains(".ipynb") || lower.contains("colab.research") {
            return "📓"
        }
        if toy.toy == "Wolfram Alpha" || lower.contains("wolframcloud.com") || lower.hasSuffix(".nb") {
            return "✴️"
        }
        if lower.contains("github.com") {
            return "🐙"
        }
        return nil
    }
}

// MARK: - Project detail

/// Loads a research project's index.md from GitHub raw and renders it
/// inside the app with the shared KaTeX markdown webview. Avoids the
/// Safari bounce the user was seeing when tapping a project toy.
struct ProjectDetailView: View {
    let title: String
    let indexURL: URL
    @State private var markdown: String = ""
    @State private var loading = true
    @State private var presentedImage: IdentifiableURL?

    var body: some View {
        Group {
            if loading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    MarkdownWebView(
                        markdown: markdown,
                        onImageTap: { url in
                            presentedImage = IdentifiableURL(url: url)
                        }
                    )
                }
            }
        }
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(item: $presentedImage) { wrapper in
            NavigationStack {
                PhotoViewer(title: wrapper.url.lastPathComponent, url: wrapper.url)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Done") { presentedImage = nil }
                        }
                    }
            }
        }
        .task {
            do {
                let (data, _) = try await URLSession.shared.data(from: indexURL)
                var md = String(data: data, encoding: .utf8) ?? ""

                // Front-matter photos: legacy projects list them explicitly.
                var photos = MarkdownHelper.extractPhotos(from: md, key: "photos")
                let dataPhotos = MarkdownHelper.extractPhotos(from: md, key: "data_photos")

                // Modern projects don't list photos in front matter — the
                // Astro layout scans photos/setup + photos/samples at build
                // time. Replicate that by querying the GitHub contents
                // API so the in-app grid has sources to show.
                if photos.isEmpty {
                    photos = await Self.scanProjectPhotos(indexURL: indexURL).shuffled()
                }

                md = MarkdownHelper.stripFrontMatter(md)
                md = MarkdownHelper.injectPhotos(md, photos: photos)
                md = MarkdownHelper.injectDataPhotos(md, photos: dataPhotos)
                let folderURL = indexURL.deletingLastPathComponent()
                md = MarkdownHelper.resolveRelativeURLs(in: md, baseURL: folderURL)
                markdown = md
            } catch {
                markdown = "# Error\n\n\(error.localizedDescription)"
            }
            loading = false
        }
    }

    /// Fetch the union of image filenames under a project's
    /// `photos/setup/` and `photos/samples/` via the GitHub contents
    /// API. Returns relative paths (e.g. `photos/setup/setup1.jpeg`) so
    /// they resolve through `MarkdownHelper.resolveRelativeURLs` with
    /// the project folder as base. Silent on failure — photos are
    /// decorative; a broken network should not crash the page.
    ///
    /// `indexURL` here is the deployed-site URL (`https://vivianweidai.com/research/projects/{folder}/index.md`),
    /// not a GitHub raw URL — we fetch markdown over the website. The
    /// repo + branch are hardcoded since this app only ever reads its
    /// own repo.
    private static func scanProjectPhotos(indexURL: URL) async -> [String] {
        let parts = indexURL.path.split(separator: "/").map(String.init)
        guard let idxPos = parts.firstIndex(of: "index.md"),
              idxPos > 0 else { return [] }
        let folder = parts[idxPos - 1]
        // public/ is the on-disk root mapped to the site root; that's
        // what the GitHub Contents API needs to see.
        let folderPath = "public/research/projects/\(folder)"

        var all: [String] = []
        for sub in ["photos/setup", "photos/samples"] {
            let apiPath = "\(folderPath)/\(sub)"
            let encoded = apiPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? apiPath
            guard let url = URL(string: "https://api.github.com/repos/vivianweidai/science/contents/\(encoded)?ref=main") else {
                continue
            }
            var req = URLRequest(url: url)
            req.setValue("application/vnd.github+json", forHTTPHeaderField: "accept")
            do {
                let (data, response) = try await URLSession.shared.data(for: req)
                guard let http = response as? HTTPURLResponse,
                      (200..<300).contains(http.statusCode) else { continue }
                let entries = try JSONDecoder().decode([GitHubContentEntry].self, from: data)
                for e in entries where e.type == "file" {
                    let lower = e.name.lowercased()
                    if lower.hasSuffix(".jpg") || lower.hasSuffix(".jpeg")
                        || lower.hasSuffix(".png") {
                        all.append("\(sub)/\(e.name)")
                    }
                }
            } catch {
                continue
            }
        }
        return all
    }
}

private struct GitHubContentEntry: Decodable {
    let name: String
    let type: String
}

/// Wrapper so a `URL` can drive SwiftUI's `.sheet(item:)` binding,
/// which requires `Identifiable`.
private struct IdentifiableURL: Identifiable {
    let url: URL
    var id: String { url.absoluteString }
}

// MARK: - Photo viewer

/// Simple in-app photo viewer for toys that are just placeholder image
/// links (the webapp shows a 📷 next to them). AsyncImage handles load
/// states; the image is centered and scaled to fit so portraits and
/// landscapes both read well without cropping.
struct PhotoViewer: View {
    let title: String
    let url: URL

    // Pinch-to-zoom + drag-to-pan state. `scale`/`offset` are the
    // committed values; `gestureScale`/`gestureOffset` accumulate the
    // in-flight gesture so the image tracks smoothly while the user
    // pinches or drags. Double-tap resets to fit.
    @State private var scale: CGFloat = 1
    @State private var gestureScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var gestureOffset: CGSize = .zero

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale * gestureScale)
                    .offset(x: offset.width + gestureOffset.width,
                            y: offset.height + gestureOffset.height)
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in gestureScale = value }
                                .onEnded { value in
                                    scale = max(1, min(scale * value, 6))
                                    gestureScale = 1
                                    if scale == 1 { offset = .zero }
                                },
                            DragGesture()
                                .onChanged { value in gestureOffset = value.translation }
                                .onEnded { value in
                                    offset.width += value.translation.width
                                    offset.height += value.translation.height
                                    gestureOffset = .zero
                                }
                        )
                    )
                    .onTapGesture(count: 2) {
                        withAnimation(.spring(response: 0.3)) {
                            if scale > 1 {
                                scale = 1; offset = .zero
                            } else {
                                scale = 2.5
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failure:
                VStack(spacing: 8) {
                    Image(systemName: "photo.badge.exclamationmark")
                        .font(.system(size: 36))
                        .foregroundStyle(.secondary)
                    Text("Couldn't load photo")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Subject filter (shared pattern with OlympiadsView)

private enum SubjectFilter: Hashable {
    case all
    case named(String)

    static let allCases: [SubjectFilter] = [
        .all,
        .named("Mathematics"),
        .named("Computing"),
        .named("Physics"),
        .named("Chemistry"),
        .named("Biology"),
        .named("Astronomy"),
    ]

    /// Matches the webapp pick pool: chem / bio / phys / comp.
    static func randomResearchSubject() -> SubjectFilter {
        let pool: [SubjectFilter] = [
            .named("Chemistry"), .named("Biology"),
            .named("Physics"), .named("Computing"),
        ]
        return pool.randomElement() ?? .all
    }

    var label: String {
        switch self {
        case .all: return "All"
        case .named(let n): return n
        }
    }

    var color: Color? {
        switch self {
        case .all: return nil
        case .named(let n): return SubjectPalette.color(for: n)
        }
    }
}

private struct SubjectFilterMenu: View {
    @Binding var selected: SubjectFilter

    var body: some View {
        Menu {
            // Plain Buttons instead of a Picker so each row's dot can
            // carry its own palette color — see OlympiadsView for the
            // same pattern.
            ForEach(SubjectFilter.allCases, id: \.self) { filter in
                Button { selected = filter } label: {
                    filterMenuRow(filter: filter, isSelected: filter == selected)
                }
            }
        } label: {
            HStack(spacing: 4) {
                if let color = selected.color {
                    Circle().fill(color).frame(width: 10, height: 10)
                }
                Text(selected.label)
                    .font(.system(size: 15, weight: .medium))
            }
        }
    }
}

@ViewBuilder
private func filterMenuRow(filter: SubjectFilter, isSelected: Bool) -> some View {
    HStack {
        Text(filter.label)
        Spacer()
        if isSelected {
            Image(systemName: "checkmark")
        }
        if let color = filter.color {
            Circle().fill(color).frame(width: 12, height: 12)
        } else {
            Image(systemName: "square.grid.2x2")
        }
    }
}

// MARK: - Cross-platform colors

/// Semantic colors that adapt to light/dark mode on iOS, with macOS
/// fallbacks for the watchOS/macOS ScienceCoreUI build. Uses UIKit/AppKit
/// bridges guarded by platform availability.
private enum ResearchColors {
    static var cardBackground: Color {
        #if canImport(UIKit)
        return Color(uiColor: .secondarySystemBackground)
        #else
        return Color.gray.opacity(0.08)
        #endif
    }

    static var technologyHeader: Color {
        #if canImport(UIKit)
        return Color(uiColor: .tertiarySystemBackground)
        #else
        return Color.gray.opacity(0.05)
        #endif
    }
}

// MARK: - Subject chip

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
