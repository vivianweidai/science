package com.vivianweidai.science.wear

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
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
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.ChipDefaults
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.Tune
import com.vivianweidai.science.core.grouping.ActivityGrouping
import com.vivianweidai.science.core.model.Activity

/** Scrollable list of olympiad + textbook entries, grouped by year.
 *  Uses [ScalingLazyColumn] — the Wear equivalent of SwiftUI's watchOS
 *  `List` — so the Digital Crown / rotating bezel scroll with native
 *  curve-scaling. */
@Composable
fun OlympiadsListView(
    yearGroups: List<ActivityGrouping.YearGroup>,
    activeFilter: String?,
    onEntry: (Activity) -> Unit,
    onFilter: () -> Unit,
) {
    val listState = rememberScalingLazyListState()
    ScalingLazyColumn(
        state = listState,
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(4.dp),
    ) {
        // Filter toolbar row (wear has no top app bar): "Olympiads"
        // label + tune icon that opens the filter sheet.
        item {
            Chip(
                onClick = onFilter,
                label = { Text("Olympiads", style = MaterialTheme.typography.title3) },
                secondaryLabel = activeFilter?.let { { Text(it) } },
                icon = {
                    Icon(Icons.Filled.Tune, contentDescription = "Filter by subject")
                },
                colors = ChipDefaults.secondaryChipColors(),
                modifier = Modifier.fillMaxWidth(),
            )
        }

        if (activeFilter != null) {
            item { ActiveFilterBadge(activeFilter) }
        }

        yearGroups.forEach { group ->
            item(key = "year-${group.year}") {
                Row(
                    modifier = Modifier.fillMaxWidth().padding(start = 8.dp, top = 4.dp),
                ) {
                    Text(
                        text = group.year,
                        fontSize = 15.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colors.onBackground,
                    )
                }
            }
            items(group.entries, key = { "act-${it.id}" }) { entry ->
                ActivityRowCard(entry, onClick = { onEntry(entry) })
            }
        }
    }
}

/** One-line "Math" pill shown above the first year group so the user
 *  never has to wonder which filter is active. Tapping the toolbar
 *  chip is how they change it. */
@Composable
private fun ActiveFilterBadge(subject: String) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(start = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        Box(
            modifier = Modifier
                .size(8.dp)
                .clip(CircleShape)
                .background(SubjectColor.color(subject))
        )
        Text(
            text = subject,
            fontSize = 12.sp,
            fontWeight = FontWeight.SemiBold,
            color = MaterialTheme.colors.onSurfaceVariant,
        )
    }
}
