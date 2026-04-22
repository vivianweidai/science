package com.vivianweidai.science.ui

import android.annotation.SuppressLint
import android.content.Intent
import android.net.Uri
import android.view.ViewGroup
import android.webkit.JavascriptInterface
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import org.json.JSONArray
import org.json.JSONObject

/**
 * Renders a markdown string with KaTeX math via a WebView hosting the
 * bundled `katex-shell.html` asset.
 *
 * Optional [tableName] + [highlightedRows] enable curriculum-specific
 * table rendering: the JS shell prepends a full-width header row with
 * the table name, removes the original column-header row, merges
 * identical first-column cells into rowspans, and applies `.highlight`
 * to data rows by index.
 *
 * The view sizes itself to rendered content via a JavaScriptInterface
 * channel (`contentHeight`) — the shell posts `document.body.scrollHeight`
 * after each render and Compose frames the outer view to that height.
 * Internal WebView scrolling is disabled so multiple tables on one
 * screen flow naturally inside an outer LazyColumn.
 */
@SuppressLint("SetJavaScriptEnabled")
@Composable
fun MarkdownWebView(
    markdown: String,
    tableName: String? = null,
    highlightedRows: List<Int> = emptyList(),
    onImageTap: ((String) -> Unit)? = null,
) {
    val context = LocalContext.current
    var contentHeight: Dp by remember { mutableStateOf(80.dp) }

    AndroidView(
        modifier = Modifier.fillMaxWidth().height(contentHeight),
        factory = {
            WebView(context).apply {
                layoutParams = ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT,
                )
                isVerticalScrollBarEnabled = false
                isHorizontalScrollBarEnabled = false
                overScrollMode = WebView.OVER_SCROLL_NEVER
                setBackgroundColor(0) // transparent
                settings.javaScriptEnabled = true
                settings.domStorageEnabled = true
                settings.allowFileAccess = true
                settings.loadWithOverviewMode = true

                addJavascriptInterface(
                    object {
                        @JavascriptInterface
                        fun postHeight(h: Double) {
                            // Called from JS on every render. Marshal back to
                            // the main thread for Compose state update.
                            post {
                                if (h > 0) contentHeight = h.dp
                            }
                        }
                    },
                    "AndroidBridge",
                )

                webViewClient = object : WebViewClient() {
                    private var loaded = false
                    private var pending: Triple<String, String?, List<Int>>? = null

                    override fun onPageFinished(view: WebView, url: String?) {
                        loaded = true
                        pending?.let { (md, tn, hr) ->
                            render(view, md, tn, hr)
                            pending = null
                        } ?: render(view, markdown, tableName, highlightedRows)
                    }

                    override fun shouldOverrideUrlLoading(
                        view: WebView,
                        req: WebResourceRequest,
                    ): Boolean {
                        val url = req.url.toString()
                        val lower = url.lowercase()
                        val isImage = lower.endsWith(".jpg") || lower.endsWith(".jpeg") ||
                                      lower.endsWith(".png") || lower.endsWith(".gif")
                        return if (isImage && onImageTap != null) {
                            onImageTap.invoke(url); true
                        } else {
                            context.startActivity(
                                Intent(Intent.ACTION_VIEW, Uri.parse(url))
                                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            )
                            true
                        }
                    }
                }

                // Load the KaTeX shell from assets. The JS then receives
                // markdown payloads via `window.renderMarkdown(...)`.
                loadUrl("file:///android_asset/katex-shell.html")
            }
        },
        update = { view ->
            render(view, markdown, tableName, highlightedRows)
        },
    )
}

private fun render(view: WebView, markdown: String, tableName: String?, highlightedRows: List<Int>) {
    val payload = JSONObject().apply {
        put("markdown", markdown)
        put("highlightedRows", JSONArray(highlightedRows))
        if (tableName != null) put("tableName", tableName)
    }
    view.evaluateJavascript("window.renderMarkdown($payload);", null)
}
