package com.vivianweidai.science.wear

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Book
import androidx.compose.material.icons.filled.EmojiEvents
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Text
import com.vivianweidai.science.core.model.Activity

/** Full-screen detail for a single activity. Reached by tapping any
 *  row in the list view.
 *
 *  The row is deliberately terse (month abbreviation, truncated name,
 *  single subject chip). The detail view is where the full record
 *  lives: untruncated name, full date string, every subject, and the
 *  historical-record metadata (highlighted / invited / type).
 *
 *  No countdown, no "days until" — the olympiads listing is a
 *  historical record, not a forward-looking tracker. */
@Composable
fun ActivityDetailView(activity: Activity) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 10.dp, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        Header(activity)

        Text(
            text = activity.name,
            fontSize = 16.sp,
            fontWeight = FontWeight.SemiBold,
        )

        SubjectChips(activity)

        Text(
            text = activity.date,
            fontSize = 12.sp,
            color = MaterialTheme.colors.onSurfaceVariant,
        )

        val badges = buildList {
            if (activity.invited == 1) add("INVITED")
            if (activity.highlighted == 1) add("HIGHLIGHTED")
        }
        if (badges.isNotEmpty()) {
            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                badges.forEach { BadgeView(it) }
            }
        }
    }
}

@Composable
private fun Header(activity: Activity) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        Icon(
            imageVector = if (activity.isOlympiad) Icons.Filled.EmojiEvents else Icons.Filled.Book,
            contentDescription = null,
            tint = if (activity.isOlympiad) Color(0.99f, 0.69f, 0.19f)
                   else MaterialTheme.colors.onSurfaceVariant,
        )
        Text(
            text = (if (activity.isOlympiad) "Olympiad" else "Textbook").uppercase(),
            fontSize = 12.sp,
            fontWeight = FontWeight.SemiBold,
            color = MaterialTheme.colors.onSurfaceVariant,
        )
    }
}

@Composable
private fun SubjectChips(activity: Activity) {
    val all = activity.subjects?.takeIf { it.isNotEmpty() } ?: listOf(activity.subject)
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        all.forEach { label ->
            Text(
                text = label,
                fontSize = 11.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color.Black.copy(alpha = 0.82f),
                modifier = Modifier
                    .clip(RoundedCornerShape(50))
                    .background(SubjectColor.color(label))
                    .padding(horizontal = 7.dp, vertical = 2.dp),
            )
        }
    }
}

@Composable
private fun BadgeView(text: String) {
    Text(
        text = text,
        fontSize = 9.sp,
        fontWeight = FontWeight.Bold,
        color = Color(0.35f, 0.27f, 0.0f),
        modifier = Modifier
            .clip(RoundedCornerShape(4.dp))
            .background(Color(1.0f, 0.84f, 0.0f))
            .padding(horizontal = 6.dp, vertical = 2.dp),
    )
}
