#if os(watchOS)
import SwiftUI

/// Olympiads + textbooks list for watchOS.
///
/// Subject picker → combined contests and textbooks sections. Same
/// `APIClient` as iPhone.
struct WatchOlympiadsView: View {
    @State private var olympiads: [Olympiad] = []
    @State private var textbooks: [Textbook] = []
    @State private var subject: String = "Mathematics"
    @State private var loading = true
    @State private var error: String?

    private let subjects = [
        "Mathematics", "Computing", "Physics", "Chemistry", "Biology", "Astronomy"
    ]

    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    ProgressView()
                } else if let error {
                    Text(error).foregroundStyle(.red).font(.caption)
                } else {
                    list
                }
            }
            .navigationTitle("Olympiads")
            .task { await load() }
        }
    }

    private var list: some View {
        List {
            Section {
                Picker("Subject", selection: $subject) {
                    ForEach(subjects, id: \.self) { Text($0).tag($0) }
                }
            }
            Section("Contests") {
                ForEach(olympiads.filter { $0.subject == subject }) { o in
                    VStack(alignment: .leading, spacing: 1) {
                        Text(o.name)
                            .font(.footnote)
                            .strikethrough(o.finished == 1)
                        Text("\(o.date) • \(o.country)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Section("Textbooks") {
                ForEach(textbooks.filter { $0.subject == subject }) { t in
                    VStack(alignment: .leading, spacing: 1) {
                        Text(t.title)
                            .font(.footnote)
                            .strikethrough(t.finished == 1)
                        Text(t.date)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func load() async {
        loading = true
        do {
            async let o = APIClient.shared.listOlympiads()
            async let t = APIClient.shared.listTextbooks()
            olympiads = try await o
            textbooks = try await t
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        loading = false
    }
}
#endif
