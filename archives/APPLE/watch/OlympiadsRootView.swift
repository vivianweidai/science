import SwiftUI
import ScienceCore

/// Top-level screen. Owns the activity list, the current subject
/// filter, and the loading/error state.
///
/// Differs from the iPhone `OlympiadsView` in two ways:
/// - The subject filter is persisted via `@AppStorage` so it sticks
///   across launches. The watch gets opened from the glance stack
///   many times a day — randomizing every time (as the iPhone does)
///   would be actively annoying.
/// - On cold start, the view reads the last successful response
///   from `ActivityCache` before the network call returns. The watch
///   radio is slow and flaky; a local cache makes the first frame
///   useful instead of a spinner. The cached list is then overwritten
///   by whatever comes back from the API, but only on success.
struct OlympiadsRootView: View {
    @State private var activities: [Activity] = []
    /// Empty string is the "All" sentinel — `@AppStorage` has no
    /// native `Optional<String>` support, so we bridge to nil via
    /// `effectiveFilter`.
    @AppStorage("watchOlympiadsFilter") private var storedFilter: String = ""
    @State private var initialLoading = true
    @State private var errorMessage: String?
    @State private var showingFilter = false

    private var effectiveFilter: String? {
        storedFilter.isEmpty ? nil : storedFilter
    }

    /// Two-way binding used by the filter sheet. Reads from
    /// `storedFilter`; writes round-trip through the same @AppStorage
    /// key so the choice persists immediately.
    private var filterBinding: Binding<String?> {
        Binding(
            get: { effectiveFilter },
            set: { storedFilter = $0 ?? "" }
        )
    }

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
                        activeFilter: effectiveFilter
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
                SubjectFilterSheet(selection: filterBinding)
            }
            .task { await load() }
            .refreshable { await refresh() }
        }
    }

    // MARK: - Grouping

    private var yearGroups: [ActivityGrouping.YearGroup] {
        let filtered = ActivityGrouping.filtered(activities, subject: effectiveFilter)
        return ActivityGrouping.groupedByYear(filtered)
    }

    // MARK: - Loading

    /// Cold-start load path. First, synchronously hydrate from the
    /// on-disk cache so the user sees content immediately. Then kick
    /// off a fresh network fetch. On success, swap in the new data
    /// and rewrite the cache. On failure, keep whatever the cache
    /// gave us (and only surface an error if we have nothing at all).
    private func load() async {
        guard activities.isEmpty else { return }

        if let cached = ActivityCache.load() {
            activities = cached
            initialLoading = false
        }

        do {
            let fresh = try await APIClient.shared.listActivities()
            activities = fresh
            errorMessage = nil
            ActivityCache.save(fresh)
        } catch {
            if activities.isEmpty {
                errorMessage = error.localizedDescription
            }
            // else: keep the cached list visible, no error UI
        }
        initialLoading = false
    }

    /// Pull-down refresh. Keep stale data on failure so the user
    /// never sees a spontaneously-empty list mid-session. Writes
    /// through to the cache on success so the next cold start
    /// reflects the most recent fetch.
    private func refresh() async {
        do {
            let fresh = try await APIClient.shared.listActivities()
            activities = fresh
            errorMessage = nil
            ActivityCache.save(fresh)
        } catch {
            // swallow — refreshable has no error UI
        }
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
