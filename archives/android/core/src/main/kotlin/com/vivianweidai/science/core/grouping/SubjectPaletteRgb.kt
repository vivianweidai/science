package com.vivianweidai.science.core.grouping

/**
 * Canonical six-subject palette as RGB tuples in the [0, 1] range.
 * Matches webapp/iOS hex colors; the UI layer converts these to
 * Compose `Color` at the edge so Core stays platform-neutral.
 */
object SubjectPaletteRgb {
    val canonicalSubjects = listOf(
        "Mathematics", "Computing", "Physics",
        "Chemistry", "Biology", "Astronomy",
    )

    data class Rgb(val r: Double, val g: Double, val b: Double)

    fun rgb(subject: String): Rgb = when (subject) {
        "Mathematics" -> Rgb(0.773, 0.851, 0.969) // #c5d9f7
        "Computing"   -> Rgb(0.851, 0.800, 0.933) // #d9ccee
        "Physics"     -> Rgb(0.976, 0.769, 0.659) // #f9c4a8
        "Chemistry"   -> Rgb(0.831, 0.910, 0.627) // #d4e8a0
        "Biology"     -> Rgb(0.659, 0.867, 0.831) // #a8ddd4
        "Astronomy"   -> Rgb(0.957, 0.761, 0.796) // #f4c2cb
        else          -> Rgb(0.82,  0.82,  0.84)  // neutral gray fallback
    }
}
