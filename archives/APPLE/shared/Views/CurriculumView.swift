import SwiftUI

/// Curriculum landing page. Visually mirrors the webapp's 6-column subject
/// grid at /curriculum/ — a color-coded card for each of the six subjects,
/// tapping into a sectioned list of topics with markdown-table content.
struct CurriculumView: View {
    private let subjects = [
        "mathematics", "computing", "physics",
        "chemistry", "biology", "astronomy",
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 150), spacing: 12)],
                    spacing: 12
                ) {
                    ForEach(subjects, id: \.self) { subject in
                        NavigationLink {
                            SubjectNotesView(subject: subject)
                        } label: {
                            SubjectCard(subject: subject)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Curriculum")
        }
    }
}

/// Large colored card for a subject on the curriculum grid.
private struct SubjectCard: View {
    let subject: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(subject.capitalized)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.black.opacity(0.82))
            Text("Tables & formulas")
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(Color.black.opacity(0.55))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(SubjectPalette.color(for: subject.capitalized))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }
}

/// Section/topic list for one subject. Groups cards by section, matching the
/// webapp drill-down (subject → section → topic → table). Each row opens a
/// `FlashcardView` that renders the markdown table with KaTeX.
struct SubjectNotesView: View {
    let subject: String

    @State private var cards: [NoteCard] = []
    @State private var initialLoading = true
    @State private var errorMessage: String?
    @State private var search = ""

    private var sectionGroups: [SectionGroup] {
        let filtered: [NoteCard]
        if search.isEmpty {
            filtered = cards
        } else {
            filtered = cards.filter {
                $0.table.localizedCaseInsensitiveContains(search) ||
                $0.topic.localizedCaseInsensitiveContains(search) ||
                $0.body.localizedCaseInsensitiveContains(search)
            }
        }

        var order: [String] = []
        var buckets: [String: [NoteCard]] = [:]
        for card in filtered {
            if buckets[card.section] == nil {
                order.append(card.section)
                buckets[card.section] = []
            }
            buckets[card.section]?.append(card)
        }
        return order.map { name in
            SectionGroup(
                name: name,
                cards: buckets[name]?.sorted { ($0.topic, $0.order) < ($1.topic, $1.order) } ?? []
            )
        }
    }

    private struct SectionGroup: Identifiable {
        var id: String { name }
        let name: String
        let cards: [NoteCard]
    }

    var body: some View {
        Group {
            if initialLoading {
                ProgressView()
            } else if cards.isEmpty, let errorMessage {
                ErrorState(message: errorMessage)
            } else {
                content
            }
        }
        .navigationTitle(subject.capitalized)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task { await load() }
        .refreshable { await refresh() }
    }

    private var content: some View {
        List {
            ForEach(sectionGroups) { group in
                Section {
                    ForEach(group.cards) { card in
                        NavigationLink {
                            FlashcardView(card: card)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(card.table)
                                    .font(.system(size: 15, weight: .semibold))
                                Text(card.topic)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text(group.name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .searchable(text: $search)
    }

    private func load() async {
        guard cards.isEmpty else { return }
        do {
            cards = try await NotesLoader.shared.cards(forSubject: subject)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        initialLoading = false
    }

    private func refresh() async {
        await NotesLoader.shared.invalidateCache(for: subject)
        do {
            cards = try await NotesLoader.shared.cards(forSubject: subject)
            errorMessage = nil
        } catch {
            // Keep stale cards on failure — the user just sees no change.
        }
    }
}

/// One curriculum table page — colored breadcrumb header matching the
/// webapp's `.curr-breadcrumb[data-subj=...]`, then the markdown table
/// rendered via KaTeX.
struct FlashcardView: View {
    let card: NoteCard

    var body: some View {
        VStack(spacing: 0) {
            BreadcrumbBar(card: card)
            MarkdownWebView(markdown: card.body)
        }
        .navigationTitle(card.table)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct BreadcrumbBar: View {
    let card: NoteCard

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(card.subject.capitalized)
                .fontWeight(.semibold)
            Text("/")
                .foregroundStyle(.secondary)
            Text(card.section)
            Text("/")
                .foregroundStyle(.secondary)
            Text(card.topic)
                .fontWeight(.semibold)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 0)
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.black.opacity(0.82))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(SubjectPalette.color(for: card.subject.capitalized))
    }
}
