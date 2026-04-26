package com.vivianweidai.science.ui

import androidx.compose.ui.graphics.Color
import com.vivianweidai.science.core.grouping.SubjectPaletteRgb

/** Compose bridge over [SubjectPaletteRgb]. The raw RGB tuples live in
 *  `:core` so a future Wear module can share them without Compose. */
object SubjectPalette {
    fun color(subject: String): Color {
        val rgb = SubjectPaletteRgb.rgb(subject)
        return Color(rgb.r.toFloat(), rgb.g.toFloat(), rgb.b.toFloat())
    }
}
