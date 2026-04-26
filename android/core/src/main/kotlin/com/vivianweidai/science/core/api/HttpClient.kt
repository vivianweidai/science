package com.vivianweidai.science.core.api

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import java.util.concurrent.TimeUnit

/** Shared OkHttp instance used by both API and curriculum loaders. */
object Http {
    val client: OkHttpClient = OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build()

    suspend fun getString(url: String): String = withContext(Dispatchers.IO) {
        val req = Request.Builder().url(url).header("cache-control", "no-cache").build()
        client.newCall(req).execute().use { response ->
            if (!response.isSuccessful) error("HTTP ${response.code} for $url")
            response.body?.string() ?: error("Empty body for $url")
        }
    }
}
