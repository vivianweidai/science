package com.vivianweidai.science.core.api

import java.net.URLEncoder

/**
 * Markdown processing utilities for turning GitHub-hosted project pages
 * into content suitable for an in-app WebView that runs marked.js +
 * KaTeX. Direct port of the iOS `MarkdownHelper`.
 */
object MarkdownHelper {

    private val mdImageRegex = Regex("""(!\[[^\]]*]\()(?!https?://)([^)]+)(\))""")
    private val htmlImgRegex = Regex("""(<img\s[^>]*src=")(?!https?://)([^"]+)(")""")
    // Markdown links: [text](path) — the (?<!!) excludes ![...](...) images.
    private val mdLinkRegex = Regex("""(?<!!)(\[[^\]]*]\()(?!https?://|mailto:|#)([^)]+)(\))""")
    private val htmlHrefRegex = Regex("""(<a\s[^>]*href=")(?!https?://|mailto:|#)([^"]+)(")""")
    // ---------- Front matter ----------

    fun stripFrontMatter(md: String): String {
        val trimmed = md.trim()
        if (!trimmed.startsWith("---")) return md
        val afterFirst = trimmed.drop(3)
        val idx = afterFirst.indexOf("\n---")
        if (idx < 0) return md
        return afterFirst.substring(idx + 4).trim('\n', '\r')
    }

    /** Extract photo paths from a specific YAML front-matter key
     *  (default `"photos"`, pass `"data_photos"` for the data grid). */
    fun extractPhotos(md: String, key: String = "photos"): List<String> {
        val trimmed = md.trim()
        if (!trimmed.startsWith("---")) return emptyList()
        val afterFirst = trimmed.drop(3)
        val end = afterFirst.indexOf("\n---")
        if (end < 0) return emptyList()
        val frontMatter = afterFirst.substring(0, end)
        val photos = mutableListOf<String>()
        var capturing = false
        for (line in frontMatter.split("\n")) {
            val t = line.trim()
            if (t.startsWith("$key:")) { capturing = true; continue }
            if (capturing) {
                if (t.startsWith("- ")) photos += t.drop(2)
                else if (t.isNotEmpty()) capturing = false
            }
        }
        return photos
    }

    /** Extract a single-line scalar YAML value (e.g. `title: "X"` or
     *  `project: Y`). Returns the value with surrounding quotes stripped,
     *  or null if the key is missing. */
    fun extractScalar(md: String, key: String): String? {
        val trimmed = md.trim()
        if (!trimmed.startsWith("---")) return null
        val afterFirst = trimmed.drop(3)
        val end = afterFirst.indexOf("\n---")
        if (end < 0) return null
        val frontMatter = afterFirst.substring(0, end)
        for (line in frontMatter.split("\n")) {
            val t = line.trim()
            if (t.startsWith("$key:")) {
                var value = t.drop(key.length + 1).trim()
                if (value.length >= 2 && value.startsWith("\"") && value.endsWith("\"")) {
                    value = value.drop(1).dropLast(1)
                }
                return value.ifEmpty { null }
            }
        }
        return null
    }

    /** Synthesise the title HTML block to prepend to a project or toy
     *  page so in-app rendering matches the website headings. Looks for:
     *    - **Project pages** — `title:` (scalar) + `sciences:` (array).
     *    - **Toy pages**     — `toy:` (scalar) + `science:` (scalar).
     *  Returns an empty string when no usable title field is present.
     *  Call against raw front-matter-bearing markdown *before*
     *  `stripFrontMatter`, then prepend the result to the stripped body. */
    fun synthesizeProjectTitle(md: String): String {
        val title = extractScalar(md, "title") ?: extractScalar(md, "toy") ?: return ""
        var sciences = extractPhotos(md, "sciences")
        if (sciences.isEmpty()) {
            extractScalar(md, "science")?.let { sciences = listOf(it) }
        }
        val slugs = mapOf(
            "Mathematics" to "math", "Computing" to "comp", "Physics" to "phys",
            "Chemistry" to "chem", "Biology" to "bio", "Astronomy" to "astro",
        )
        val chips = sciences.mapNotNull { s ->
            slugs[s]?.let { """<span class="chip $it">$s</span>""" }
        }.joinToString("")
        val chipBlock = if (chips.isEmpty()) "" else """<span class="project-chips">$chips</span>"""
        return """<div class="project-title"><h1>$title</h1>$chipBlock</div>""" + "\n\n"
    }

    /** Remove the `## Technology` heading and its inline
     *  `<ul class="updates-list">…</ul>` block from a project's markdown
     *  body. Native UI renders the technology table from the project's
     *  `toys:` frontmatter array + ContentStore lookup, so the inline
     *  list would otherwise show up twice (and with broken external
     *  links). Idempotent: returns the input unchanged when the section
     *  is missing. */
    fun stripTechnologySection(md: String): String {
        val h = md.indexOf("## Technology")
        if (h < 0) return md
        val end = md.indexOf("</ul>", startIndex = h)
        if (end < 0) return md
        return md.substring(0, h) + md.substring(end + "</ul>".length)
    }

    // ---------- Photo injection ----------

    fun injectPhotos(md: String, photos: List<String>): String =
        injectImageSources(md, photos, idPrefix = "photo-", altText = "Experiment photo")

    fun injectDataPhotos(md: String, photos: List<String>): String =
        injectImageSources(md, photos, idPrefix = "data-", altText = "Data sheet")

    private fun injectImageSources(
        md: String, photos: List<String>, idPrefix: String, altText: String,
    ): String {
        if (photos.isEmpty()) return md
        var result = md
        for ((i, photo) in photos.withIndex()) {
            val pattern = """<img id="$idPrefix$i" alt="$altText">"""
            val replacement = """<img id="$idPrefix$i" src="$photo" alt="$altText">"""
            result = result.replace(pattern, replacement)
        }
        return result
    }

    // ---------- URL resolution ----------

    /** Rewrite relative image/link paths to absolute raw.githubusercontent URLs.
     *  `baseUrl` must be the raw URL of the folder that contains index.md. */
    fun resolveRelativeUrls(markdown: String, baseUrl: String): String {
        val base = if (baseUrl.endsWith("/")) baseUrl else "$baseUrl/"
        var result = markdown
        result = replaceRelative(result, mdImageRegex, base)
        result = replaceRelative(result, htmlImgRegex, base)
        result = replaceRelative(result, mdLinkRegex, base)
        result = replaceRelative(result, htmlHrefRegex, base)
        return result
    }

    private fun replaceRelative(text: String, regex: Regex, base: String): String =
        regex.replace(text) { m ->
            val (before, path, after) = m.destructured
            val encoded = path.split("/").joinToString("/") {
                URLEncoder.encode(it, "UTF-8").replace("+", "%20")
            }
            "$before$base$encoded$after"
        }
}
