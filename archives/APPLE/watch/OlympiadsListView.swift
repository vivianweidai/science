import SwiftUI
import ScienceCore

/// Scrollable list of olympiad + textbook entries, grouped by year.
/// Uses SwiftUI `List` with `Section` headers for native Digital
/// Crown scrolling and row recycling — don't switch to
/// ScrollView+LazyVStack, which gives up those watchOS ergonomics.
struct OlympiadsListView: View {
    let yearGroups: [ActivityGrouping.YearGroup]
    let activeFilter: String?

    var body: some View {
        List {
            if let activeFilter {
                ActiveFilterBadge(subject: activeFilter)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 4, trailing: 0))
            }

            ForEach(yearGroups) { group in
                Section {
                    ForEach(group.entries) { entry in
                        ActivityRowView(activity: entry)
                    }
                } header: {
                    Text(group.year)
                        .font(.system(size: 15, weight: .bold))
                }
            }
        }
        .listStyle(.plain)
    }
}

/// One-line "Math" pill shown above the first year group so the
/// user never has to wonder which filter is active. Tapping the
/// toolbar filter icon is how they change it.
private struct ActiveFilterBadge: View {
    let subject: String

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(SubjectColor.color(for: subject))
                .frame(width: 8, height: 8)
            Text(subject)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
    }
}
