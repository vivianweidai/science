import SwiftUI
import ScienceCore

/// Unified chronological timeline of olympiads + textbooks, visually matching
/// the webapp at /olympiads/. Groups entries by year (newest first, Future
/// bucket last), renders each row with a month label, type icon, subject
/// chips, and name with optional INVITED badge.
///
/// The webapp's implementation lives in olympiads/index.md — keep this view
/// in sync with the timeline JS there when the design changes.
struct OlympiadsView: View {
    @State private var activities: [Activity] = []
    @State private var subject: SubjectFilter = SubjectFilter.randomSubject()
    @State private var initialLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if initialLoading {
                    ProgressView()
                } else if activities.isEmpty, let errorMessage {
                    ErrorState(message: errorMessage)
                } else {
                    timelineContent
                }
            }
            .navigationTitle("Olympiads")
            .task { await load() }
            .refreshable { await refresh() }
        }
    }

    // MARK: - Timeline

    private var timelineContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                SubjectTabStrip(selected: $subject)
                    .padding(.horizontal)
                    .padding(.top, 4)
                    .padding(.bottom, 8)

                ForEach(yearGroups, id: \.year) { group in
                    YearSection(year: group.year, entries: group.entries)
                }
            }
            .padding(.bottom, 24)
        }
    }

    // MARK: - Grouping
    //
    // The filter + year bucketing logic lives in `ScienceCore` so the
    // watchOS companion app shares identical semantics. This view just
    // maps its enum filter onto the shared helpers.

    private var yearGroups: [ActivityGrouping.YearGroup] {
        let subjectName: String? = {
            if case .named(let name) = subject { return name }
            return nil
        }()
        let filtered = ActivityGrouping.filtered(activities, subject: subjectName)
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

    /// Pull-to-refresh: keep stale data on failure, only replace on success.
    /// Fixes the bug where the previous `load()` set `loading = true` and
    /// wiped the list every time the user pulled down.
    private func refresh() async {
        do {
            let fresh = try await APIClient.shared.listActivities()
            activities = fresh
            errorMessage = nil
        } catch {
            // Silently keep stale data. SwiftUI's refreshable shows no
            // error UI by design — users will notice nothing changed.
        }
    }
}

// MARK: - Subject filter

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

    /// Pick a random non-"All" subject for the initial filter on launch,
    /// matching the webapp which randomly preselects one of the six subject
    /// tabs each page load (see olympiads/index.md line 16-18).
    static func randomSubject() -> SubjectFilter {
        let subjects: [SubjectFilter] = allCases.filter {
            if case .all = $0 { return false }
            return true
        }
        return subjects.randomElement() ?? .all
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

private struct SubjectTabStrip: View {
    @Binding var selected: SubjectFilter

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SubjectFilter.allCases, id: \.self) { filter in
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selected = filter
                                proxy.scrollTo(filter, anchor: .center)
                            }
                        } label: {
                            TabChipLabel(
                                label: filter.label,
                                isSelected: selected == filter,
                                selectedColor: filter.color
                            )
                        }
                        .buttonStyle(.plain)
                        .id(filter)
                    }
                }
            }
            .onAppear {
                // The initial subject is a random non-"All" filter (to
                // match the webapp's random tab preselect). On narrow
                // screens the selected chip can be offscreen to the
                // right — scroll it into view so users know which
                // subject they're looking at.
                DispatchQueue.main.async {
                    proxy.scrollTo(selected, anchor: .center)
                }
            }
            .onChange(of: selected) { _, newValue in
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

/// Single chip in the subject tab strip. Extracted into its own view so the
/// SwiftUI type-checker can resolve it in reasonable time — inlined, the
/// nested ternaries around background + foreground color hit the "unable to
/// type-check in reasonable time" limit.
private struct TabChipLabel: View {
    let label: String
    let isSelected: Bool
    let selectedColor: Color?

    private var fillColor: Color {
        guard isSelected else { return PlatformColors.chipInactive }
        return selectedColor ?? PlatformColors.chipNeutralActive
    }

    private var textColor: Color {
        isSelected ? .black : .primary.opacity(0.8)
    }

    var body: some View {
        Text(label)
            .font(.system(size: 13, weight: .semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Capsule().fill(fillColor))
            .foregroundStyle(textColor)
    }
}

/// Cross-platform gray colors for the tab chip strip. Avoids
/// `Color(.systemGray4)` etc. which only resolve on iOS/tvOS contextual type.
private enum PlatformColors {
    static let chipInactive = Color(red: 0.93, green: 0.93, blue: 0.95)
    static let chipNeutralActive = Color(red: 0.78, green: 0.78, blue: 0.80)
}

/// Simple error display used when the initial fetch fails. Avoids
/// `ContentUnavailableView` which requires macOS 14 and complicates
/// host type-checking via `swift build`.
struct ErrorState: View {
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
            Text("Could not load")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Year section

private struct YearSection: View {
    let year: String
    let entries: [Activity]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(year)
                .font(.system(size: 17, weight: .bold))
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 4)

            ForEach(entries) { entry in
                ActivityRow(activity: entry)
                Divider()
                    .padding(.leading, 16)
            }
        }
    }
}

// MARK: - Activity row

private struct ActivityRow: View {
    let activity: Activity

    /// The month label shown in the timeline column. The source-of-truth
    /// dates are full month names ("December 2025"); we abbreviate to three
    /// letters here so longer names don't wrap in the narrow fixed-width
    /// column. Source data is untouched.
    private var month: String {
        guard activity.date != "Future" else { return "" }
        let full = activity.date.split(separator: " ").first.map(String.init) ?? ""
        return String(full.prefix(3))
    }

    private var chips: [String] {
        if let subjects = activity.subjects, !subjects.isEmpty {
            return subjects
        }
        return [activity.subject]
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(month)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 56, alignment: .leading)

            TypeIcon(isOlympiad: activity.isOlympiad)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    ForEach(chips, id: \.self) { subject in
                        SubjectChip(subject: subject)
                    }
                }
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(activity.name)
                        .font(.system(size: 14))
                        .fixedSize(horizontal: false, vertical: true)
                    if activity.invited == 1 {
                        InvitedBadge()
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            activity.highlighted == 1
                ? Color(red: 1.0, green: 0.96, blue: 0.31).opacity(0.5)
                : Color.clear
        )
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

// MARK: - Invited badge

private struct InvitedBadge: View {
    var body: some View {
        Text("INVITED")
            .font(.system(size: 9, weight: .bold))
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 1.0, green: 0.84, blue: 0.0))
            )
            .foregroundStyle(Color(red: 0.35, green: 0.27, blue: 0.0))
    }
}

// MARK: - Type icons

private struct TypeIcon: View {
    let isOlympiad: Bool

    var body: some View {
        if isOlympiad {
            OlympicRings()
                .frame(width: 22, height: 12)
        } else {
            Text("📖")
                .font(.system(size: 13))
        }
    }
}

/// Simplified Olympic rings — 5 circles in two rows matching the webapp SVG.
private struct OlympicRings: View {
    var body: some View {
        ZStack {
            ring(color: Color(red: 0.0, green: 0.51, blue: 0.78), offset: CGPoint(x: -8, y: -2))    // blue
            ring(color: .black, offset: CGPoint(x: 0, y: -2))
            ring(color: Color(red: 0.93, green: 0.20, blue: 0.31), offset: CGPoint(x: 8, y: -2))   // red
            ring(color: Color(red: 0.99, green: 0.69, blue: 0.19), offset: CGPoint(x: -4, y: 3))   // yellow
            ring(color: Color(red: 0.0, green: 0.65, blue: 0.32), offset: CGPoint(x: 4, y: 3))     // green
        }
    }

    private func ring(color: Color, offset: CGPoint) -> some View {
        Circle()
            .strokeBorder(color, lineWidth: 1.2)
            .frame(width: 7, height: 7)
            .offset(x: offset.x, y: offset.y)
    }
}

// MARK: - Subject palette

/// Thin SwiftUI wrapper over `ScienceCore.SubjectPaletteRGB`. The raw
/// (r,g,b) tuples live in Core so the watchOS companion can share them
/// without dragging SwiftUI into the platform-neutral target.
enum SubjectPalette {
    static func color(for subject: String) -> Color {
        let rgb = SubjectPaletteRGB.rgb(for: subject)
        return Color(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }
}
