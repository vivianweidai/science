package com.vivianweidai.science.ui

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.MenuBook
import androidx.compose.material.icons.outlined.EmojiEvents
import androidx.compose.material.icons.outlined.Science
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.saveable.rememberSaveableStateHolder
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import com.vivianweidai.science.core.ContentStore
import kotlinx.coroutines.launch

/** Root Compose screen for the phone app.
 *
 * Default tab is Olympiads. On first launch we kick off a parallel
 * preload via the shared [ContentStore] so Curriculum + Research
 * populate in the background — by the time the user taps them, the
 * data is already there (see ContentStore for the rationale). */
@Composable
fun RootTabView(store: ContentStore = ContentStore.shared) {
    var tab by rememberSaveable { mutableStateOf(Tab.Olympiads) }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) { scope.launch { store.preloadAll() } }

    // Preserves per-tab UI state (nested NavController back stacks,
    // scroll positions, etc.) when the user switches tabs. Without this
    // the inactive tab is removed from composition and its NavController
    // is reset — so e.g. drilling into Curriculum → Chemistry → Atoms →
    // First Law and then tapping Olympiads loses the position.
    val stateHolder = rememberSaveableStateHolder()

    Scaffold(
        bottomBar = {
            NavigationBar {
                Tab.entries.forEach { t ->
                    NavigationBarItem(
                        selected = tab == t,
                        onClick = { tab = t },
                        icon = { Icon(t.icon(), contentDescription = t.label) },
                        label = { Text(t.label) },
                    )
                }
            }
        },
    ) { padding ->
        stateHolder.SaveableStateProvider(key = tab.name) {
            when (tab) {
                Tab.Curriculum -> CurriculumView(store, Modifier.fillMaxSize().padding(padding))
                Tab.Olympiads  -> OlympiadsView (store, Modifier.fillMaxSize().padding(padding))
                Tab.Research   -> ResearchView  (store, Modifier.fillMaxSize().padding(padding))
            }
        }
    }
}

enum class Tab(val label: String) {
    Curriculum("Curriculum"),
    Olympiads ("Olympiads"),
    Research  ("Research");

    @Composable
    fun icon() = when (this) {
        Curriculum -> Icons.AutoMirrored.Outlined.MenuBook
        Olympiads  -> Icons.Outlined.EmojiEvents
        Research   -> Icons.Outlined.Science
    }
}
