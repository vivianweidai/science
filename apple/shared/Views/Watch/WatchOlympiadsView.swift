#if os(watchOS)
import SwiftUI

/// Olympiads + textbooks list for watchOS.
struct WatchOlympiadsView: View {
    @State private var activities: [Activity] = []
    @State private var subject: String = "All"
    @State private var loading = true
    @State private var error: String?

    private let subjects = [
        "All", "Mathematics", "Computing", "Physics", "Chemistry", "Biology", "Astronomy"
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

    private var filtered: [Activity] {
        let items = subject == "All" ? activities : activities.filter { $0.subject == subject }
        return items.sorted { $0.sortKey > $1.sortKey }
    }

    private var list: some View {
        List {
            Section {
                Picker("Subject", selection: $subject) {
                    ForEach(subjects, id: \.self) { Text($0).tag($0) }
                }
            }
            Section("Contests") {
                ForEach(filtered.filter(\.isOlympiad)) { a in
                    VStack(alignment: .leading, spacing: 1) {
                        Text(a.name)
                            .font(.footnote)                        Text("\(a.date) \(a.country.map { "• \($0)" } ?? "")")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Section("Textbooks") {
                ForEach(filtered.filter(\.isTextbook)) { a in
                    VStack(alignment: .leading, spacing: 1) {
                        Text(a.name)
                            .font(.footnote)                        Text(a.date)
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
            activities = try await APIClient.shared.listActivities()
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        loading = false
    }
}
#endif
