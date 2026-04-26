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
    private val scriptRegex = Regex("""<script[\s\S]*?</script>""")
    private val styleRegex = Regex("""<style[\s\S]*?</style>""")
    // Kramdown `<div ... markdown="1">...</div>` wrappers exist purely to
    // tell the webapp's markdown engine "process markdown inside this
    // HTML block". marked.js (in the in-app WebView) doesn't understand
    // that hint and leaves the enclosed markdown as raw text. We match
    // the entire wrapper as a single non-greedy block and replace with
    // just its contents, so the opener AND its matching `</div>` are
    // removed together. Naive "strip opener + strip next </div>"
    // misfires on pages that also carry structural divs (photo-grid,
    // etc.) — it would clip the structural div's close tag instead.
    private val kramdownWrapperRegex = Regex("""<div[^>]*\bmarkdown="1"[^>]*>([\s\S]*?)</div>""")

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

    // ---------- Jekyll cleanup ----------

    fun stripJekyllSyntax(md: String): String {
        var result = scriptRegex.replace(md, "")
        result = styleRegex.replace(result, "")
        // Unwrap every kramdown `<div markdown="1">…</div>` in one pass,
        // keeping the inner contents. Non-greedy `[\s\S]*?` so multiple
        // wrappers on the same page each match their own tag pair.
        result = kramdownWrapperRegex.replace(result) { it.groupValues[1] }
        return result.lineSequence()
            .filter { !it.contains("{{") && !it.contains("{%") }
            .joinToString("\n")
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
