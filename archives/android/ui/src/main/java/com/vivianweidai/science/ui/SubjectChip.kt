package com.vivianweidai.science.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/** Pill-shaped chip used in the olympiads timeline and research cards. */
@Composable
fun SubjectChip(subject: String, modifier: Modifier = Modifier) {
    Text(
        text = subject,
        fontSize = 10.sp,
        fontWeight = FontWeight.SemiBold,
        color = Color.Black.copy(alpha = 0.82f),
        modifier = modifier
            .clip(RoundedCornerShape(50))
            .background(SubjectPalette.color(subject))
            .padding(horizontal = 7.dp, vertical = 2.dp),
    )
}
