import SwiftUI
import ScienceCore

/// Full-screen detail for a single activity. Reached by tapping any
/// row in `OlympiadsListView`.
///
/// The row view is deliberately terse (month abbreviation, truncated
/// name, single subject chip) because the watch canvas is narrow. The
/// detail view is where the full information lives: untruncated name,
/// full date string from the source JSON, every subject when an
/// activity spans multiple disciplines, and the historical-record
/// metadata (highlighted, invited, type).
///
/// No countdown, no "days until" — the olympiads listing is a
/// historical record, not a forward-looking tracker.
struct ActivityDetailView: View {
    let activity: Activity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header

                Text(activity.name)
                    .font(.system(size: 16, weight: .semibold))
                    .fixedSize(horizontal: false, vertical: true)

                subjectChips

                Text(activity.date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)

                if !badges.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(badges, id: \.self) { badge in
                            BadgeView(text: badge)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(activity.isOlympiad ? "Olympiad" : "Textbook")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Type glyph + type label, mirroring the small icon used in the
    /// list row but at a size that actually reads well on the detail
    /// canvas.
    private var header: some View {
        HStack(spacing: 6) {
            Image(systemName: activity.isOlympiad ? "trophy.fill" : "book.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(activity.isOlympiad
                    ? Color(red: 0.99, green: 0.69, blue: 0.19)
                    : Color.secondary)
            Text(activity.isOlympiad ? "Olympiad" : "Textbook")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Spacer(minLength: 0)
        }
    }

    /// Every subject the activity participates in — not just the
    /// primary like the list row shows. Wraps to new lines when
    /// multiple disciplines don't fit on one.
    private var subjectChips: some View {
        let all: [String]
        if let subjects = activity.subjects, !subjects.isEmpty {
            all = subjects
        } else {
            all = [activity.subject]
        }
        return FlowingChips(labels: all)
    }

    /// One chip per badge state. Kept as short strings so the flow
    /// layout can pack them onto a watch screen without overflowing.
    private var badges: [String] {
        var out: [String] = []
        if activity.invited == 1 { out.append("INVITED") }
        if activity.highlighted == 1 { out.append("HIGHLIGHTED") }
        return out
    }
}

private struct BadgeView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(red: 1.0, green: 0.84, blue: 0.0))
            )
            .foregroundStyle(Color(red: 0.35, green: 0.27, blue: 0.0))
    }
}

/// Simple wrapping chip row. Watch SwiftUI doesn't have a built-in
/// flow layout and `Layout` conformances on older watchOS were
/// finicky — this is a hand-rolled GeometryReader-free approach that
/// works for our small N (at most three or four subjects).
private struct FlowingChips: View {
    let labels: [String]

    var body: some View {
        // Two-row layout works for up to six chips; the olympiads
        // dataset currently has at most three subjects on any single
        // activity so rows almost always collapse to one.
        let rows = split(labels, perRow: 3)
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 4) {
                    ForEach(row, id: \.self) { label in
                        SubjectPillDetail(subject: label)
                    }
                }
            }
        }
    }

    private func split(_ items: [String], perRow: Int) -> [[String]] {
        guard !items.isEmpty else { return [] }
        var out: [[String]] = []
        var current: [String] = []
        for item in items {
            current.append(item)
            if current.count == perRow {
                out.append(current)
                current = []
            }
        }
        if !current.isEmpty { out.append(current) }
        return out
    }
}

private struct SubjectPillDetail: View {
    let subject: String

    var body: some View {
        Text(subject)
            .font(.system(size: 10, weight: .semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(SubjectColor.color(for: subject)))
            .foregroundStyle(Color.black.opacity(0.82))
    }
}
