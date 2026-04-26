package com.vivianweidai.science.core.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.net.URI
import java.net.URLEncoder

/** Strongly-typed mirror of `content/research/toys.json`. */
@Serializable
data class ResearchTopic(
    val id: Int,
    val science: String,
    @SerialName("science_slug") val scienceSlug: String,
    val topic: String,
    val description: String? = null,
    val technologies: List<ResearchTechnology>,
)

@Serializable
data class ResearchTechnology(
    val id: Int,
    val technology: String,
    val description: String? = null,
    val toys: List<ResearchToy>,
)

@Serializable
data class ResearchToy(
    val id: Int,
    val toy: String,
    val specs: String? = null,
    val available: Int? = null,
    val url: String? = null,
    @SerialName("project_url") val projectUrl: String? = null,
) {
    val isAvailable: Boolean get() = (available ?: 0) == 1

    /** Raw GitHub URL for the project's `index.md`, if this toy points at
     *  an in-repo project. `null` when the toy has no project link. */
    val projectIndexUrl: String?
        get() {
            val path = projectUrl ?: return null
            val trimmed = if (path.startsWith("/")) path.drop(1) else path
            val withIndex = if (trimmed.endsWith("/")) trimmed + "index.md" else "$trimmed/index.md"
            // project_url is a page URL like "/research/projects/<folder>/"; the raw
            // markdown lives at /content/research/projects/<folder>/index.md.
            return "https://vivianweidai.com/content/$withIndex"
        }

    /** External URL to open (Wolfram, GitHub, Colab) — or resolved to a raw
     *  GitHub URL when `url` is a repo-relative path like a photo link. */
    val externalUrl: String?
        get() {
            val raw = url ?: return null
            if (raw.startsWith("http://") || raw.startsWith("https://")) return raw
            val trimmed = if (raw.startsWith("/")) raw.drop(1) else raw
            val encoded = trimmed.split("/").joinToString("/") {
                URLEncoder.encode(it, "UTF-8").replace("+", "%20")
            }
            return "https://vivianweidai.com/$encoded"
        }
}

@Serializable
data class ResearchToysResponse(val topics: List<ResearchTopic>)
