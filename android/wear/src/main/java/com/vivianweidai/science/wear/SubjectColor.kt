package com.vivianweidai.science.wear

import androidx.compose.ui.graphics.Color
import com.vivianweidai.science.core.grouping.SubjectPaletteRgb

/** Compose bridge over [SubjectPaletteRgb]. Defined in the wear module
 *  so :core can stay free of Compose. */
object SubjectColor {
    fun color(subject: String): Color {
        val rgb = SubjectPaletteRgb.rgb(subject)
        return Color(rgb.r.toFloat(), rgb.g.toFloat(), rgb.b.toFloat())
    }
}
