package com.vivianweidai.science.core

import com.vivianweidai.science.core.api.ApiClient
import com.vivianweidai.science.core.api.CurriculumLoader
import com.vivianweidai.science.core.model.Activity
import com.vivianweidai.science.core.model.CurriculumManifest
import com.vivianweidai.science.core.model.ResearchTopic
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

/**
 * Single shared data store for the three top-level tabs. Compose views
 * collect these StateFlows so they recompose automatically when each
 * slot fills in.
 *
 * Why a store instead of per-screen state: `LaunchedEffect(Unit)` inside
 * each tab only fires when the tab composes. If the user jumps to
 * Curriculum while the root-level preload is still fetching, a
 * per-screen launch would spin its own request. A shared store means
 * the root preload writes results once and every currently-visible
 * screen repaints.
 */
class ContentStore(
    private val api: ApiClient = ApiClient.shared,
    private val curriculum: CurriculumLoader = CurriculumLoader.shared,
    private val scope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Default),
) {
    private val _activities = MutableStateFlow<List<Activity>?>(null)
    val activities: StateFlow<List<Activity>?> = _activities.asStateFlow()

    private val _topics = MutableStateFlow<List<ResearchTopic>?>(null)
    val topics: StateFlow<List<ResearchTopic>?> = _topics.asStateFlow()

    private val _manifest = MutableStateFlow<CurriculumManifest?>(null)
    val manifest: StateFlow<CurriculumManifest?> = _manifest.asStateFlow()

    private val _activitiesError = MutableStateFlow<String?>(null)
    val activitiesError: StateFlow<String?> = _activitiesError.asStateFlow()

    private val _topicsError = MutableStateFlow<String?>(null)
    val topicsError: StateFlow<String?> = _topicsError.asStateFlow()

    private val _manifestError = MutableStateFlow<String?>(null)
    val manifestError: StateFlow<String?> = _manifestError.asStateFlow()

    private val preloadMutex = Mutex()
    private var inFlight: Deferred<Unit>? = null

    /** Kick off all three fetches in parallel. Idempotent — a second
     *  call during launch joins the existing job. */
    suspend fun preloadAll() {
        val job = preloadMutex.withLock {
            inFlight ?: scope.async {
                val a = async { loadActivities() }
                val t = async { loadTopics() }
                val m = async { loadManifest() }
                awaitAll(a, t, m)
                Unit
            }.also { inFlight = it }
        }
        job.await()
    }

    /** Force a fresh fetch (pull-to-refresh). Clears caches + local
     *  state so every tab shows a spinner, then repopulates. */
    suspend fun refreshAll() {
        preloadMutex.withLock {
            inFlight?.cancel()
            inFlight = null
        }
        api.invalidate()
        curriculum.invalidate()
        _activities.value = null
        _topics.value = null
        _manifest.value = null
        _activitiesError.value = null
        _topicsError.value = null
        _manifestError.value = null
        preloadAll()
    }

    private suspend fun loadActivities() {
        runCatching { api.listActivities() }
            .onSuccess { _activities.value = it; _activitiesError.value = null }
            .onFailure { _activitiesError.value = it.message ?: it::class.simpleName }
    }

    private suspend fun loadTopics() {
        runCatching { api.listResearchTopics() }
            .onSuccess { _topics.value = it; _topicsError.value = null }
            .onFailure { _topicsError.value = it.message ?: it::class.simpleName }
    }

    private suspend fun loadManifest() {
        runCatching { curriculum.manifest() }
            .onSuccess { _manifest.value = it; _manifestError.value = null }
            .onFailure { _manifestError.value = it.message ?: it::class.simpleName }
    }

    fun launchPreload() {
        scope.launch { preloadAll() }
    }

    companion object {
        val shared: ContentStore by lazy { ContentStore() }
    }
}
