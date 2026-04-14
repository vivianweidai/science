import SwiftUI
import ScienceCore

/// Full-screen picker sheet for the subject filter. Seven rows —
/// "All" followed by the six canonical subjects in their canonical
/// order (Mathematics → Astronomy). Tapping a row sets the binding
/// and dismisses.
struct SubjectFilterSheet: View {
    @Binding var selection: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Button {
                    selection = nil
                    dismiss()
                } label: {
                    filterRow(label: "All", color: nil, isSelected: selection == nil)
                }

                ForEach(SubjectPaletteRGB.canonicalSubjects, id: \.self) { subject in
                    Button {
                        selection = subject
                        dismiss()
                    } label: {
                        filterRow(
                            label: subject,
                            color: SubjectColor.color(for: subject),
                            isSelected: selection == subject
                        )
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Subject")
        }
    }

    private func filterRow(label: String, color: Color?, isSelected: Bool) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color ?? Color.gray.opacity(0.4))
                .frame(width: 12, height: 12)
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
            Spacer(minLength: 0)
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}
