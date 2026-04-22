package com.vivianweidai.science.wear

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.items
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.ChipDefaults
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Text
import com.vivianweidai.science.core.grouping.SubjectPaletteRgb

/** Full-screen picker for the subject filter. Seven rows — "All"
 *  followed by the six canonical subjects in their canonical order.
 *  Tapping a row passes the choice up and dismisses. */
@Composable
fun SubjectFilterSheet(current: String?, onSelect: (String?) -> Unit) {
    ScalingLazyColumn(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(4.dp),
    ) {
        item {
            Text(
                text = "Subject",
                fontSize = 15.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            )
        }
        item {
            FilterRow(
                label = "All",
                color = null,
                isSelected = current == null,
                onClick = { onSelect(null) },
            )
        }
        items(SubjectPaletteRgb.canonicalSubjects) { subject ->
            FilterRow(
                label = subject,
                color = SubjectColor.color(subject),
                isSelected = current == subject,
                onClick = { onSelect(subject) },
            )
        }
    }
}

@Composable
private fun FilterRow(
    label: String,
    color: Color?,
    isSelected: Boolean,
    onClick: () -> Unit,
) {
    Chip(
        onClick = onClick,
        colors = ChipDefaults.secondaryChipColors(),
        modifier = Modifier.fillMaxWidth(),
        icon = {
            Box(
                modifier = Modifier
                    .size(12.dp)
                    .clip(CircleShape)
                    .background(color ?: Color.Gray.copy(alpha = 0.4f))
            )
        },
        label = {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth(),
            ) {
                Text(label, fontWeight = FontWeight.SemiBold)
                if (isSelected) {
                    Icon(
                        Icons.Filled.Check,
                        contentDescription = "Selected",
                        tint = MaterialTheme.colors.onSurfaceVariant,
                        modifier = Modifier.size(12.dp),
                    )
                }
            }
        },
    )
}
