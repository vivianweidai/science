package com.vivianweidai.science.ui

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlin.random.Random

sealed class SubjectFilter {
    object All : SubjectFilter()
    data class Named(val name: String) : SubjectFilter()

    val label: String
        get() = when (this) { All -> "All"; is Named -> name }

    val color: Color?
        get() = when (this) { All -> null; is Named -> SubjectPalette.color(name) }

    companion object {
        val allCases: List<SubjectFilter> =
            listOf(All) + canonicalSubjects.map(::Named)

        /** Matches webapp: random non-"All" subject at launch. */
        fun randomSubject(): SubjectFilter =
            Named(canonicalSubjects[Random.nextInt(canonicalSubjects.size)])

        /** Research-page pick pool, matching the webapp. */
        fun randomResearchSubject(): SubjectFilter {
            val pool = listOf("Chemistry", "Biology", "Physics", "Computing")
            return Named(pool[Random.nextInt(pool.size)])
        }
    }
}

/** Toolbar subject-filter dropdown used by Olympiads and Research tabs. */
@Composable
fun SubjectFilterMenu(
    selected: SubjectFilter,
    onSelect: (SubjectFilter) -> Unit,
    modifier: Modifier = Modifier,
) {
    var expanded by remember { mutableStateOf(false) }
    Box(modifier = modifier) {
        // TextButton / IconButton squeeze long labels ("Biology") onto two
        // lines because they constrain to a 48dp square. A plain
        // clickable Row lets the text breathe at its natural width.
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(4.dp),
            modifier = Modifier
                .wrapContentWidth()
                .clickable { expanded = true }
                .padding(horizontal = 12.dp, vertical = 8.dp),
        ) {
            selected.color?.let { c ->
                androidx.compose.foundation.Canvas(modifier = Modifier.size(10.dp)) {
                    drawCircle(c)
                }
            }
            Text(
                text = selected.label,
                fontSize = 15.sp,
                fontWeight = FontWeight.Medium,
                maxLines = 1,
            )
        }
        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
            SubjectFilter.allCases.forEach { filter ->
                DropdownMenuItem(
                    text = { Text(filter.label) },
                    leadingIcon = {
                        // Colored dot for each of the six subjects so the
                        // dropdown reads like the iOS filter menu. "All"
                        // gets a neutral checkmark slot.
                        filter.color?.let { c ->
                            androidx.compose.foundation.Canvas(
                                modifier = Modifier.size(12.dp),
                            ) { drawCircle(c) }
                        }
                    },
                    trailingIcon = {
                        if (filter == selected) Icon(Icons.Filled.Check, null)
                    },
                    onClick = {
                        onSelect(filter)
                        expanded = false
                    },
                )
            }
        }
    }
}

