#if os(watchOS)
import SwiftUI

/// Curriculum browser for watchOS.
///
/// Subject → section → table list → plain-text flashcard body. LaTeX in
/// the body is shown as-is (no KaTeX on watchOS). `NotesLoader` is shared
/// with the iPhone app via `ScienceCore`.
struct WatchCurriculumView: View {
    private let subjects = [
        "mathematics", "computing", "physics", "chemistry", "biology", "astronomy"
    ]

    var body: some View {
        NavigationStack {
            List(subjects, id: \.self) { subject in
                NavigationLink(subject.capitalized) {
                    WatchSubjectView(subject: subject)
                }
            }
            .navigationTitle("Curriculum")
        }
    }
}

struct WatchSubjectView: View {
    let subject: String

    @State private var cards: [NoteCard] = []
    @State private var selectedSection: String? = nil
    @State private var loading = true
    @State private var error: String?

    var sections: [String] {
        Array(Set(cards.map(\.section))).sorted()
    }

    var filtered: [NoteCard] {
        guard let section = selectedSection else { return cards }
        return cards.filter { $0.section == section }
    }

    var body: some View {
        Group {
            if loading {
                ProgressView()
            } else if let error {
                Text(error).foregroundStyle(.red).font(.caption)
            } else if selectedSection == nil {
                List(sections, id: \.self) { section in
                    Button(section.capitalized) {
                        selectedSection = section
                    }
                }
            } else {
                List(filtered) { card in
                    NavigationLink {
                        WatchFlashcardView(card: card)
                    } label: {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(card.table).font(.headline)
                            Text(card.topic).font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("All") { selectedSection = nil }
                    }
                }
            }
        }
        .navigationTitle(subject.capitalized)
        .task { await load() }
    }

    private func load() async {
        do {
            cards = try await NotesLoader.shared.cards(forSubject: subject)
        } catch {
            self.error = error.localizedDescription
        }
        loading = false
    }
}

struct WatchFlashcardView: View {
    let card: NoteCard

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text(card.topic)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(card.body)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .navigationTitle(card.table)
    }
}
#endif
