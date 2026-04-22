package com.vivianweidai.science.wear

import android.content.Context
import com.vivianweidai.science.core.model.Activity
import com.vivianweidai.science.core.model.ActivityList
import kotlinx.serialization.json.Json
import java.io.File

/**
 * On-disk cache of the last successful `olympiads.json` fetch.
 *
 * The watch radio is slow and intermittently unavailable — a cold
 * launch that has to round-trip to GitHub before showing any content
 * can take seconds of spinner time. This helper writes every successful
 * response to the app's cacheDir so the next launch can render the old
 * list on the first frame, then silently swap in the network result.
 *
 * Scoped to the wear module because phones are essentially always on
 * good networks — adding a cache there would be premature.
 */
object ActivityCache {
    private const val FILE_NAME = "olympiads_cache.json"
    private val json = Json { ignoreUnknownKeys = true }

    private fun file(context: Context): File = File(context.cacheDir, FILE_NAME)

    /** Read the cached list synchronously. Returns null if no cache
     *  exists, the file is unreadable, or decoding fails. */
    fun load(context: Context): List<Activity>? = runCatching {
        val f = file(context)
        if (!f.exists()) return null
        json.decodeFromString<ActivityList>(f.readText()).items
    }.getOrNull()

    /** Atomically replace the cached payload. Swallows write failures —
     *  the user-visible state is unchanged and the next successful
     *  fetch will overwrite. */
    fun save(context: Context, items: List<Activity>) {
        runCatching {
            val tmp = File(context.cacheDir, "$FILE_NAME.tmp")
            tmp.writeText(json.encodeToString(ActivityList.serializer(), ActivityList(items)))
            tmp.renameTo(file(context))
        }
    }
}
