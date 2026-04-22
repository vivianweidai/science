package com.vivianweidai.science.wear

import android.content.Context

/** SharedPreferences-backed subject filter — the Wear equivalent of iOS
 *  `@AppStorage("watchOlympiadsFilter")`. Empty string is the "All"
 *  sentinel (SharedPreferences has no native `Optional<String>`). The
 *  watch gets opened many times a day; sticky filter > random. */
object FilterPrefs {
    private const val PREFS = "wearOlympiads"
    private const val KEY = "watchOlympiadsFilter"

    fun read(context: Context): String? {
        val v = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(KEY, "") ?: ""
        return v.ifEmpty { null }
    }

    fun write(context: Context, value: String?) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit().putString(KEY, value ?: "").apply()
    }
}
