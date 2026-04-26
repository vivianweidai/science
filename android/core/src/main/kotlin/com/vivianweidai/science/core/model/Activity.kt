package com.vivianweidai.science.core.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class Activity(
    val id: Int,
    val type: String,
    val subject: String,
    val date: String,
    @SerialName("sort_key") val sortKey: String,
    val name: String,
    val highlighted: Int,
    val subjects: List<String>? = null,
    val invited: Int? = null,
    val borderline: Int? = null,
    val competitive: Int? = null,
    @SerialName("photo_url") val photoUrl: String? = null,
) {
    val isOlympiad: Boolean get() = type == "olympiad"
    val isTextbook: Boolean get() = type == "textbook"

    val photoAbsoluteUrl: String?
        get() = photoUrl?.takeIf { it.isNotEmpty() }?.let {
            val trimmed = if (it.startsWith("/")) it.drop(1) else it
            "https://vivianweidai.com/$trimmed"
        }
}

@Serializable
data class ActivityList(val items: List<Activity>)
