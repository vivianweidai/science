import SwiftUI
import ScienceCore

/// Thin SwiftUI bridge over `SubjectPaletteRGB` for the watch target.
/// Mirrors `SubjectPalette` on the iOS side — both wrap the same
/// platform-neutral RGB tuples in `ScienceCore` so the two apps are
/// guaranteed to render identical chip colors.
enum SubjectColor {
    static func color(for subject: String) -> Color {
        let rgb = SubjectPaletteRGB.rgb(for: subject)
        return Color(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }
}
