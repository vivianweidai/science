#if os(iOS)
import SwiftUI

struct CurriculumView: View {
    private let subjects = ["mathematics", "computing", "physics", "chemistry", "biology", "astronomy"]

    var body: some View {
        NavigationStack {
            List(subjects, id: \.self) { subject in
                NavigationLink(subject.capitalized) {
                    SubjectNotesView(subject: subject)
                }
            }
            .navigationTitle("Curriculum")
        }
    }
}

struct SubjectNotesView: View {
    let subject: String

    @State private var cards: [NoteCard] = []
    @State private var search = ""
    @State private var selectedSection: String? = nil
    @State private var loading = true
    @State private var error: String?

    var sections: [String] {
        Array(Set(cards.map(\.section))).sorted()
    }

    var filtered: [NoteCard] {
        cards.filter { card in
            (selectedSection == nil || card.section == selectedSection) &&
            (search.isEmpty ||
                card.table.localizedCaseInsensitiveContains(search) ||
                card.topic.localizedCaseInsensitiveContains(search) ||
                card.body.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        Group {
            if loading {
                ProgressView()
            } else if let error {
                Text(error).foregroundStyle(.red).padding()
            } else {
                content
            }
        }
        .navigationTitle(subject.capitalized)
        .task { await load() }
    }

    private var content: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    chip(label: "All", selected: selectedSection == nil) {
                        selectedSection = nil
                    }
                    ForEach(sections, id: \.self) { section in
                        chip(label: section, selected: selectedSection == section) {
                            selectedSection = section
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)

            List(filtered) { card in
                NavigationLink {
                    FlashcardView(card: card)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.table).font(.headline)
                        Text("\(card.section) • \(card.topic)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .searchable(text: $search)
        }
    }

    private func chip(label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(selected ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func load() async {
        do {
            cards = try await NotesLoader.shared.cards(forSubject: subject)
            loading = false
        } catch {
            self.error = error.localizedDescription
            self.loading = false
        }
    }
}

struct FlashcardView: View {
    let card: NoteCard

    var body: some View {
        MarkdownWebView(markdown: card.body)
            .navigationTitle(card.table)
            .navigationBarTitleDisplayMode(.inline)
    }
}
#endif
