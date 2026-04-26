package com.vivianweidai.science.core.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

/**
 * Strongly-typed mirror of `content/truth/curriculum.json`.
 *
 * The build script emits subjects/sections/topics/tables in a canonical
 * order (never alphabetical). We decode the JSON verbatim, then re-order
 * subjects into the canonical webapp sequence.
 */
data class CurriculumManifest(val subjects: List<CurriculumSubject>) {
    fun subject(slug: String): CurriculumSubject? = subjects.firstOrNull { it.slug == slug }

    companion object {
        /** Webapp canonical subject order (see curriculum/index.md). */
        val canonicalSubjectOrder = listOf(
            "mathematics", "computing", "physics",
            "chemistry", "biology", "astronomy",
        )

        private val json = Json { ignoreUnknownKeys = true }

        fun decode(raw: String): CurriculumManifest {
            val decoded = json.decodeFromString<Map<String, CurriculumSubject>>(raw)
            val remaining = decoded.toMutableMap()
            val ordered = buildList {
                for (slug in canonicalSubjectOrder) {
                    remaining.remove(slug)?.let { add(it) }
                }
                addAll(remaining.values)
            }
            return CurriculumManifest(ordered)
        }
    }
}

@Serializable
data class CurriculumSubject(
    val slug: String,
    val name: String,
    val sections: List<CurriculumSection>,
)

@Serializable
data class CurriculumSection(
    val slug: String,
    val name: String,
    val topics: List<CurriculumTopic>,
)

@Serializable
data class CurriculumTopic(
    val slug: String,
    val name: String,
    val tables: List<CurriculumTable>,
)

@Serializable
data class CurriculumTable(
    val name: String,
    val order: Int,
    val path: String,
    @SerialName("highlighted_rows") val highlightedRows: List<Int>,
)
