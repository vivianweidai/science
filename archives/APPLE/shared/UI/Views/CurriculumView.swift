import SwiftUI
import ScienceCore

/// Curriculum landing page. Mirrors the webapp at /curriculum/ with a
/// vertical list of the six subjects in canonical order (Mathematics first,
/// Astronomy last). Tapping a subject cascades into sections → topics →
/// tables, each level preserving the order that `build_curriculum.py`
/// writes into `archives/CONTENT/curriculum.json`.
struct CurriculumView: View {
    @State private var manifest: CurriculumManifest?
    @State private var initialLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if initialLoading {
                    ProgressView()
                } else if manifest == nil, let errorMessage {
                    ErrorState(message: errorMessage)
                } else if let manifest {
                    subjectList(manifest)
                }
            }
            .navigationTitle("Curriculum")
            .task { await load() }
            .refreshable { await refresh() }
        }
    }

    private func subjectList(_ manifest: CurriculumManifest) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(manifest.subjects) { subject in
                    NavigationLink {
                        CurriculumSubjectView(subject: subject)
                    } label: {
                        SubjectRow(subject: subject)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    private func load() async {
        do {
            manifest = try await CurriculumLoader.shared.manifest()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        initialLoading = false
    }

    private func refresh() async {
        await CurriculumLoader.shared.invalidate()
        do {
            manifest = try await CurriculumLoader.shared.manifest()
            errorMessage = nil
        } catch {
            // keep stale manifest
        }
    }
}

/// Single colored row on the curriculum landing page.
private struct SubjectRow: View {
    let subject: CurriculumSubject

    var body: some View {
        HStack {
            Text(subject.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.black.opacity(0.82))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(SubjectPalette.color(for: subject.name))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Subject → Sections

/// Level 2: one subject expanded into its sections. The webapp uses a
/// 3-col section grid; iOS collapses this into a simple list in the same
/// canonical order (`build_curriculum.py:SECTION_ORDER`).
///
/// The subject color appears as a breadcrumb strip directly below the
/// navigation bar — matching `CurriculumTopicView` at level 4 — rather
/// than tinting the navigation bar itself. Tinting the nav bar with
/// `.toolbarBackground` caused the bar color to bleed onto the first
/// `List` row during the push transition and flash away once the
/// animation settled; the manual strip sidesteps that bug and keeps
/// all three curriculum levels visually consistent.
struct CurriculumSubjectView: View {
    let subject: CurriculumSubject

    var body: some View {
        VStack(spacing: 0) {
            SubjectBreadcrumb(subject: subject, trail: [])
            List {
                ForEach(subject.sections) { section in
                    NavigationLink {
                        CurriculumSectionView(subject: subject, section: section)
                    } label: {
                        Text(section.name)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(subject.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Section → Topics

/// Level 3: a single section expanded into its topics. One row per topic;
/// the subtitle lists the actual table names belonging to that topic
/// (in source-of-truth order) so the user sees concrete content, not
/// just a count.
///
/// Like `CurriculumSubjectView`, this carries the subject color through
/// a manual breadcrumb strip below the navigation bar rather than
/// `.toolbarBackground`.
struct CurriculumSectionView: View {
    let subject: CurriculumSubject
    let section: CurriculumSection

    var body: some View {
        VStack(spacing: 0) {
            SubjectBreadcrumb(subject: subject, trail: [section.name])
            List {
                ForEach(section.topics) { topic in
                    NavigationLink {
                        CurriculumTopicView(subject: subject, section: section, topic: topic)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(topic.name)
                                .font(.system(size: 16, weight: .semibold))
                            Text(topic.tables.map(\.name).joined(separator: ", "))
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(section.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

/// Colored banner placed immediately below the navigation bar showing
/// the active subject (and optional trail). Mirrors the `breadcrumb`
/// inside `CurriculumTopicView` so levels 2, 3, and 4 all look alike.
private struct SubjectBreadcrumb: View {
    let subject: CurriculumSubject
    /// Extra path segments after the subject name. Empty on the
    /// subject landing view, `[section.name]` on the section view.
    let trail: [String]

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(subject.name)
                .fontWeight(.semibold)
            ForEach(trail, id: \.self) { piece in
                Text("/")
                    .foregroundStyle(.secondary)
                Text(piece)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer(minLength: 0)
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.black.opacity(0.82))
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(SubjectPalette.color(for: subject.name))
    }
}

// MARK: - Topic → Tables

/// Level 4: render every table belonging to this topic, stacked in the
/// order that `build_curriculum.py` emits them. The colored breadcrumb
/// at the top mirrors `.curr-breadcrumb[data-subj=...]` on the webapp.
struct CurriculumTopicView: View {
    let subject: CurriculumSubject
    let section: CurriculumSection
    let topic: CurriculumTopic

    var body: some View {
        VStack(spacing: 0) {
            breadcrumb
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(topic.tables) { table in
                        CurriculumTableCard(table: table)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(topic.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(SubjectPalette.color(for: subject.name), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        #endif
    }

    private var breadcrumb: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(subject.name)
                .fontWeight(.semibold)
            Text("/")
                .foregroundStyle(.secondary)
            Text(section.name)
            Text("/")
                .foregroundStyle(.secondary)
            Text(topic.name)
                .fontWeight(.semibold)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: 0)
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.black.opacity(0.82))
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(SubjectPalette.color(for: subject.name))
    }
}

/// One rendered table — fetches its markdown body lazily and hands it to
/// MarkdownWebView along with the table name (for the prepended header row)
/// and highlighted row indices from the manifest.
struct CurriculumTableCard: View {
    let table: CurriculumTable

    @State private var markdownBody: String = ""
    @State private var loading = true
    @State private var failed = false

    var body: some View {
        Group {
            if loading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 80)
            } else if failed {
                VStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle")
                    Text("Failed to load \(table.name)")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 80)
            } else {
                // No explicit frame — MarkdownWebView sizes itself to its
                // content via a contentHeight binding, and the outer
                // LazyVStack + ScrollView owns the actual scroll gesture.
                MarkdownWebView(
                    markdown: markdownBody,
                    tableName: table.name,
                    highlightedRows: table.highlightedRows
                )
            }
        }
        .task { await load() }
    }

    private func load() async {
        guard markdownBody.isEmpty else { return }
        do {
            markdownBody = try await CurriculumLoader.shared.body(for: table)
            loading = false
        } catch {
            failed = true
            loading = false
        }
    }
}
