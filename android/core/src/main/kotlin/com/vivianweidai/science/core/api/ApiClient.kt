package com.vivianweidai.science.core.api

import com.vivianweidai.science.core.model.Activity
import com.vivianweidai.science.core.model.ActivityList
import com.vivianweidai.science.core.model.ResearchTopic
import com.vivianweidai.science.core.model.ResearchToysResponse
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.serialization.json.Json

/**
 * Read-only client for activity listings (olympiads + textbooks) and
 * research toys. The source of truth is YAML in content/truth/, built
 * to JSON by a Python script, then fetched straight from GitHub raw.
 * No backend, no auth, no writes.
 */
class ApiClient {
    private val mutex = Mutex()
    private val json = Json { ignoreUnknownKeys = true }
    private var cachedActivities: List<Activity>? = null
    private var cachedTopics: List<ResearchTopic>? = null

    suspend fun listActivities(): List<Activity> = mutex.withLock {
        cachedActivities?.let { return it }
        val body = Http.getString("$BASE_URL/olympiads.json")
        val list = json.decodeFromString<ActivityList>(body).items
        cachedActivities = list
        list
    }

    suspend fun listResearchTopics(): List<ResearchTopic> = mutex.withLock {
        cachedTopics?.let { return it }
        val body = Http.getString("$BASE_URL/toys.json")
        val topics = json.decodeFromString<ResearchToysResponse>(body).topics
        cachedTopics = topics
        topics
    }

    suspend fun invalidate() = mutex.withLock {
        cachedActivities = null
        cachedTopics = null
    }

    companion object {
        const val BASE_URL = "https://vivianweidai.com/content/truth"
        val shared = ApiClient()
    }
}
