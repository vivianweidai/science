package com.vivianweidai.science.core.api

import com.vivianweidai.science.core.model.CurriculumManifest
import com.vivianweidai.science.core.model.CurriculumTable
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import java.net.URLEncoder

/**
 * Loads the curriculum manifest and individual table markdown files on
 * demand. Mirrors iOS's CurriculumLoader: the manifest is cached for the
 * life of the object; invalidate() on pull-to-refresh.
 */
class CurriculumLoader {
    private val mutex = Mutex()
    private var cachedManifest: CurriculumManifest? = null

    suspend fun manifest(): CurriculumManifest = mutex.withLock {
        cachedManifest?.let { return it }
        val body = Http.getString(MANIFEST_URL)
        val parsed = CurriculumManifest.decode(body)
        cachedManifest = parsed
        parsed
    }

    suspend fun invalidate() = mutex.withLock { cachedManifest = null }

    /** Fetch raw markdown body for a given table. `path` is relative to
     *  the content/curriculum/source/ folder on GitHub. */
    suspend fun body(table: CurriculumTable): String {
        val encoded = table.path.split("/").joinToString("/") {
            URLEncoder.encode(it, "UTF-8").replace("+", "%20")
        }
        return Http.getString("$RAW_BASE_URL$encoded")
    }

    companion object {
        private const val MANIFEST_URL =
            "https://vivianweidai.com/content/truth/curriculum.json"
        private const val RAW_BASE_URL =
            "https://vivianweidai.com/content/curriculum/source/"
        val shared = CurriculumLoader()
    }
}
