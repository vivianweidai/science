import SwiftUI
import ScienceCore

/// Top-level screen. Owns the activity list, the current subject
/// filter, and the loading/error state. Mirrors the iPhone
/// `OlympiadsView`'s lifecycle (task-load, refreshable, silent
/// retain-stale-on-failure) so both apps behave the same way
/// offline / after first launch.
struct OlympiadsRootView: View {
    @State private var activities: [Activity] = []
    @State private var subjectFilter: String? = WatchSubjectFilter.randomDefault()
    @State private var initialLoading = true
    @State private var errorMessage: String?
    @State private var showingFilter = false

    var body: some View {
        NavigationStack {
            Group {
                if initialLoading {
                    ProgressView()
                } else if activities.isEmpty, let errorMessage {
                    WatchErrorView(message: errorMessage)
                } else {
                    OlympiadsListView(
                        yearGroups: yearGroups,
                        activeFilter: subjectFilter
                    )
                }
            }
            .navigationTitle("Olympiads")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityLabel("Filter by subject")
                }
            }
            .sheet(isPresented: $showingFilter) {
                SubjectFilterSheet(selection: $subjectFilter)
            }
            .task { await load() }
            .refreshable { await refresh() }
        }
    }

    // MARK: - Grouping

    private var yearGroups: [ActivityGrouping.YearGroup] {
        let filtered = ActivityGrouping.filtered(activities, subject: subjectFilter)
        return ActivityGrouping.groupedByYear(filtered)
    }

    // MARK: - Loading

    private func load() async {
        guard activities.isEmpty else { return }
        do {
            activities = try await APIClient.shared.listActivities()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        initialLoading = false
    }

    /// Pull-down refresh. Keep stale data on failure so the user
    /// never sees a spontaneously-empty list mid-session.
    private func refresh() async {
        do {
            let fresh = try await APIClient.shared.listActivities()
            activities = fresh
            errorMessage = nil
        } catch {
            // swallow — refreshable has no error UI
        }
    }
}

/// Match the iPhone's "random non-All subject on launch" behavior so
/// the two apps feel consistent. The watch user can swap immediately
/// via the filter button in the toolbar.
enum WatchSubjectFilter {
    static func randomDefault() -> String? {
        SubjectPaletteRGB.canonicalSubjects.randomElement()
    }
}

struct WatchErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 22))
                .foregroundStyle(.secondary)
            Text("Could not load")
                .font(.headline)
            Text(message)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(.horizontal, 8)
    }
}
