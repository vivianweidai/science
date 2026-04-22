package com.vivianweidai.science.wear

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.wear.compose.material.CircularProgressIndicator
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Text
import androidx.wear.compose.navigation.SwipeDismissableNavHost
import androidx.wear.compose.navigation.composable
import androidx.wear.compose.navigation.rememberSwipeDismissableNavController
import com.vivianweidai.science.core.api.ApiClient
import com.vivianweidai.science.core.grouping.ActivityGrouping
import com.vivianweidai.science.core.model.Activity

/**
 * Top-level wear screen. Owns the activity list, the current subject
 * filter, and the loading/error state.
 *
 * Differs from the phone OlympiadsView in two ways:
 * - Subject filter is persisted via SharedPreferences so it sticks
 *   across launches. Watch gets opened many times a day; randomizing
 *   would be actively annoying (mirrors iOS `@AppStorage` choice).
 * - On cold start, we synchronously hydrate from [ActivityCache]
 *   before the network call returns, so the first frame is useful
 *   instead of a spinner. Cached list is overwritten only on fetch
 *   success.
 */
@Composable
fun OlympiadsRootView() {
    val context = LocalContext.current
    val nav = rememberSwipeDismissableNavController()

    var activities by remember { mutableStateOf<List<Activity>>(emptyList()) }
    var storedFilter by remember { mutableStateOf(FilterPrefs.read(context) ?: "") }
    var initialLoading by remember { mutableStateOf(true) }
    var errorMessage by remember { mutableStateOf<String?>(null) }

    val effectiveFilter: String? = storedFilter.ifEmpty { null }

    LaunchedEffect(Unit) {
        if (activities.isEmpty()) {
            ActivityCache.load(context)?.let {
                activities = it
                initialLoading = false
            }
            runCatching { ApiClient.shared.listActivities() }
                .onSuccess { fresh ->
                    activities = fresh
                    errorMessage = null
                    ActivityCache.save(context, fresh)
                }
                .onFailure { e ->
                    if (activities.isEmpty()) {
                        errorMessage = e.message ?: e::class.simpleName
                    }
                    // else: keep the cached list visible, no error UI
                }
            initialLoading = false
        }
    }

    val groups = remember(activities, effectiveFilter) {
        val filtered = ActivityGrouping.filtered(activities, effectiveFilter)
        ActivityGrouping.groupedByYear(filtered)
    }

    SwipeDismissableNavHost(navController = nav, startDestination = "list") {
        composable("list") {
            Box(Modifier.fillMaxSize()) {
                when {
                    initialLoading -> Box(
                        Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center,
                    ) { CircularProgressIndicator() }

                    activities.isEmpty() && errorMessage != null ->
                        WatchErrorView(errorMessage!!)

                    else -> OlympiadsListView(
                        yearGroups = groups,
                        activeFilter = effectiveFilter,
                        onEntry = { activity ->
                            nav.navigate("detail/${activity.id}")
                        },
                        onFilter = { nav.navigate("filter") },
                    )
                }
            }
        }

        composable("detail/{id}") { back ->
            val id = back.arguments?.getString("id")?.toIntOrNull()
            val a = activities.firstOrNull { it.id == id }
            if (a != null) ActivityDetailView(a)
            else Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Text("Not found")
            }
        }

        composable("filter") {
            SubjectFilterSheet(
                current = effectiveFilter,
                onSelect = { picked ->
                    storedFilter = picked ?: ""
                    FilterPrefs.write(context, picked)
                    nav.popBackStack()
                },
            )
        }
    }
}

@Composable
fun WatchErrorView(message: String) {
    Box(
        modifier = Modifier.fillMaxSize().padding(horizontal = 12.dp, vertical = 8.dp),
        contentAlignment = Alignment.Center,
    ) {
        androidx.compose.foundation.layout.Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = androidx.compose.foundation.layout.Arrangement.spacedBy(4.dp),
        ) {
            Text("Could not load", style = MaterialTheme.typography.title3)
            Text(
                text = message,
                style = MaterialTheme.typography.caption2,
                color = MaterialTheme.colors.onSurfaceVariant,
                maxLines = 3,
            )
        }
    }
}
