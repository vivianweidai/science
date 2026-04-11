import SwiftUI

struct OlympiadsView: View {
    @State private var olympiads: [Olympiad] = []
    @State private var textbooks: [Textbook] = []
    @State private var subject: String = "Mathematics"
    @State private var loading = true
    @State private var error: String?

    private let subjects = ["Mathematics", "Computing", "Physics", "Chemistry", "Biology", "Astronomy"]

    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    ProgressView()
                } else if let error {
                    Text(error).foregroundStyle(.red).padding()
                } else {
                    list
                }
            }
            .navigationTitle("Olympiads")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Subject", selection: $subject) {
                        ForEach(subjects, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                }
            }
            .task { await load() }
            .refreshable { await load() }
        }
    }

    private var filteredOlympiads: [Olympiad] {
        olympiads.filter { $0.subject == subject }
    }

    private var filteredTextbooks: [Textbook] {
        textbooks.filter { $0.subject == subject }
    }

    private var list: some View {
        List {
            Section("Contests") {
                ForEach(filteredOlympiads) { o in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(o.name).strikethrough(o.finished == 1)
                        Text("\(o.date) • \(o.country)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Section("Textbooks") {
                ForEach(filteredTextbooks) { t in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(t.title).strikethrough(t.finished == 1)
                        Text(t.date)
                            .font(.caption)
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
