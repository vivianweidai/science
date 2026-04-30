package com.vivianweidai.science.core.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.net.URI
import java.net.URLEncoder

/** Strongly-typed mirror of `public/research/toys.json`. */
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
    val hero: String? = null,
    @SerialName("toy_url") val toyUrl: String? = null,
    val projects: List<ResearchToyProject>? = null,
) {
    val isAvailable: Boolean get() = (available ?: 0) == 1

    /** Absolute URL for the toy's hero image. Resolves repo-relative
     *  paths (the common case) against the site origin. */
    val heroUrl: String?
        get() {
            val h = hero ?: return null
            if (h.startsWith("http://") || h.startsWith("https://")) return h
            val trimmed = if (h.startsWith("/")) h.drop(1) else h
            return "https://vivianweidai.com/$trimmed"
        }

    /** Raw URL for the toy page's `index.md` — what the in-app toy tap
     *  renders. Toy pages live at `/research/toys/<science>/<toy>/` and
     *  carry the toy-specific equipment/results/specs body. Replaces the
     *  project-page routing that pre-dated the toy-pages refactor. */
    val toyIndexUrl: String?
        get() {
            val path = toyUrl ?: return null
            val trimmed = if (path.startsWith("/")) path.drop(1) else path
            val encoded = trimmed.split("/").joinToString("/") {
                URLEncoder.encode(it, "UTF-8").replace("+", "%20")
            }
            val withIndex = if (encoded.endsWith("/")) encoded + "index.md" else "$encoded/index.md"
            return "https://vivianweidai.com/$withIndex"
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

/** Per-toy project entry baked into toys.json by build_toys.py — combines
 *  reverse-scanned local projects (whose frontmatter `toys:` references
 *  this toy) with the toy's own `extra_projects:` placeholders. Lets
 *  iOS/Android render the toy detail view without re-scanning every
 *  project at runtime. */
@Serializable
data class ResearchToyProject(
    val date: String,                 // YYYY-MM-DD
    val title: String,
    val url: String,
    val sciences: List<String> = emptyList(),
    val folder: String? = null,        // null for `extra_projects` placeholders
) {
    /** URL of the project's `index.md` for in-app rendering, when this
     *  is a local in-repo project (folder is set). Returns null for
     *  placeholders — those go through `externalUrl`. */
    val indexUrl: String?
        get() {
            if (folder == null) return null
            val trimmed = if (url.startsWith("/")) url.drop(1) else url
            val withIndex = if (trimmed.endsWith("/")) trimmed + "index.md" else "$trimmed/index.md"
            return "https://vivianweidai.com/$withIndex"
        }

    /** External URL for placeholder projects (extra_projects entries). */
    val externalUrl: String?
        get() {
            if (folder != null) return null
            if (url.startsWith("http://") || url.startsWith("https://")) return url
            return null
        }
}
