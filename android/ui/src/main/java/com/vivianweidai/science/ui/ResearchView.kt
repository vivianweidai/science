package com.vivianweidai.science.ui

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import coil.compose.AsyncImage
import com.vivianweidai.science.core.ContentStore
import com.vivianweidai.science.core.api.Http
import com.vivianweidai.science.core.api.MarkdownHelper
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import com.vivianweidai.science.core.model.ResearchTechnology
import com.vivianweidai.science.core.model.ResearchTopic
import com.vivianweidai.science.core.model.ResearchToy
import java.net.URLEncoder

/** Toy browser mirroring the webapp at /research/. Topics grouped into
 *  cards with subject chip; each card nests technologies + their toys. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ResearchView(store: ContentStore, modifier: Modifier = Modifier) {
    val topics by store.topics.collectAsStateWithLifecycle()
    val error by store.topicsError.collectAsStateWithLifecycle()
    val nav = rememberNavController()

    var filter by rememberSaveable(
        stateSaver = Saver<SubjectFilter, String>(
            save = { (it as? SubjectFilter.Named)?.name ?: "__all__" },
            restore = { if (it == "__all__") SubjectFilter.All else SubjectFilter.Named(it) },
        )
    ) { mutableStateOf<SubjectFilter>(SubjectFilter.randomResearchSubject()) }

    NavHost(navController = nav, startDestination = "list", modifier = modifier) {
        composable("list") {
            Scaffold(
                topBar = {
                    TopAppBar(
                        title = { Text("Research") },
                        actions = {
                            SubjectFilterMenu(
                                selected = filter,
                                onSelect = { filter = it },
                            )
                        },
                    )
                },
            ) { p ->
                Box(Modifier.padding(p)) {
                    when {
                        topics != null -> TopicList(
                            topics = topics!!.filterBy(filter),
                            onProject = { title, url ->
                                val encoded = URLEncoder.encode(url, "UTF-8")
                                nav.navigate("project/${URLEncoder.encode(title, "UTF-8")}/$encoded")
                            },
                            onPhoto = { title, url ->
                                val encoded = URLEncoder.encode(url, "UTF-8")
                                nav.navigate("photo/${URLEncoder.encode(title, "UTF-8")}/$encoded")
                            },
                        )
                        error != null -> ErrorState(error!!)
                        else -> LoadingState(
                            "Loading toys",
                            "Fetching research topics from GitHub.",
                        )
                    }
                }
            }
        }
        // NavHost already URL-decodes path arguments once, so do NOT call
        // Uri.decode here. Double-decoding was turning `%20` (the real
        // percent-encoding of a space in the GitHub raw URL) back into a
        // literal space, which broke every downstream image fetch AND
        // kept marked.js from parsing `[text](url with space)` as a
        // link on research project pages (Extension tables rendered
        // their URLs as raw text instead of links).
        composable("project/{title}/{url}") { back ->
            val title = back.arguments?.getString("title") ?: ""
            val url = back.arguments?.getString("url") ?: ""
            ProjectDetailScreen(
                title = title,
                indexUrl = url,
                onBack = { nav.popBackStack() },
                onImageTap = { imageUrl ->
                    // Use the same push-from-right viewer that the main
                    // research page uses for photo-placeholder toys, so
                    // in-page image links behave the same as toy-row
                    // image links.
                    val encoded = URLEncoder.encode(imageUrl, "UTF-8")
                    val titleSeg = URLEncoder.encode(
                        imageUrl.substringAfterLast('/'), "UTF-8",
                    )
                    nav.navigate("photo/$titleSeg/$encoded")
                },
            )
        }
        composable("photo/{title}/{url}") { back ->
            val title = back.arguments?.getString("title") ?: ""
            val url = back.arguments?.getString("url") ?: ""
            PhotoViewerScreen(title, url) { nav.popBackStack() }
        }
    }
}

private fun List<ResearchTopic>.filterBy(filter: SubjectFilter): List<ResearchTopic> =
    when (filter) {
        SubjectFilter.All -> this
        is SubjectFilter.Named -> filter { it.science == filter.name }
    }

@Composable
private fun TopicList(
    topics: List<ResearchTopic>,
    onProject: (String, String) -> Unit,
    onPhoto: (String, String) -> Unit,
) {
    LazyColumn(
        contentPadding = androidx.compose.foundation.layout.PaddingValues(vertical = 12.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp),
    ) {
        if (topics.isEmpty()) {
            item {
                Text(
                    text = "No toys yet.",
                    fontSize = 14.sp,
                    fontStyle = FontStyle.Italic,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(horizontal = 16.dp),
                )
            }
        }
        items(topics, key = { it.id }) { topic ->
            TopicCard(topic, onProject, onPhoto)
        }
    }
}

@Composable
private fun TopicCard(
    topic: ResearchTopic,
    onProject: (String, String) -> Unit,
    onPhoto: (String, String) -> Unit,
) {
    Surface(
        shape = RoundedCornerShape(10.dp),
        color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f),
        border = BorderStroke(1.dp, SubjectPalette.color(topic.science).copy(alpha = 0.7f)),
        modifier = Modifier.fillMaxWidth().padding(horizontal = 12.dp),
    ) {
        Row {
            // Left accent bar, mirrors webapp .toys-accent-* border.
            Box(
                modifier = Modifier
                    .width(4.dp)
                    .fillMaxSize()
                    .background(SubjectPalette.color(topic.science))
            )
            Column(Modifier.weight(1f)) {
                // Header
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 14.dp, end = 12.dp, top = 10.dp, bottom = 10.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                ) {
                    Text(
                        topic.topic,
                        fontSize = 15.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.weight(1f, fill = false),
                    )
                    SubjectChip(topic.science)
                }
                HorizontalDivider()
                topic.technologies.forEach { tech ->
                    TechnologyBlock(tech, onProject, onPhoto)
                }
            }
        }
    }
}

@Composable
private fun TechnologyBlock(
    tech: ResearchTechnology,
    onProject: (String, String) -> Unit,
    onPhoto: (String, String) -> Unit,
) {
    Column {
        Text(
            text = tech.technology,
            fontSize = 13.sp,
            fontWeight = FontWeight.SemiBold,
            modifier = Modifier
                .fillMaxWidth()
                .background(MaterialTheme.colorScheme.surfaceContainer)
                .padding(start = 14.dp, end = 12.dp, top = 6.dp, bottom = 6.dp),
        )
        tech.toys.forEachIndexed { i, toy ->
            ToyRow(toy, onProject, onPhoto)
            if (i != tech.toys.lastIndex) {
                HorizontalDivider(modifier = Modifier.padding(start = 28.dp))
            }
        }
    }
}

@Composable
private fun ToyRow(
    toy: ResearchToy,
    onProject: (String, String) -> Unit,
    onPhoto: (String, String) -> Unit,
) {
    val context = LocalContext.current
    val projectUrl = toy.projectIndexUrl
    val externalUrl = toy.externalUrl
    val hasLink = projectUrl != null || externalUrl != null

    val onClick: (() -> Unit)? = when {
        projectUrl != null -> ({ onProject(toy.toy, projectUrl) })
        externalUrl != null && externalUrl.isImageUrl() -> ({ onPhoto(toy.toy, externalUrl) })
        externalUrl != null -> ({
            context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(externalUrl)))
        })
        else -> null
    }

    val row = @Composable {
        Row(
            verticalAlignment = Alignment.Top,
            modifier = Modifier
                .fillMaxWidth()
                .padding(start = 28.dp, end = 12.dp, top = 8.dp, bottom = 8.dp),
        ) {
            Column(Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = toy.toy,
                        fontSize = 14.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = if (hasLink) MaterialTheme.colorScheme.primary
                                else MaterialTheme.colorScheme.onSurface,
                    )
                    toyUrlIcon(toy)?.let { Text(" $it", fontSize = 11.sp) }
                }
                if (!toy.specs.isNullOrEmpty()) {
                    Text(
                        text = toy.specs!!,
                        fontSize = 12.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
            if (toy.isAvailable) {
                Icon(
                    Icons.Filled.Check,
                    contentDescription = "Available",
                    tint = Color(0.10f, 0.50f, 0.22f),
                )
            }
        }
    }
    if (onClick != null) Surface(onClick = onClick, color = Color.Transparent) { row() }
    else row()
}

private fun String.isImageUrl(): Boolean {
    val l = lowercase()
    return l.endsWith(".jpg") || l.endsWith(".jpeg") ||
           l.endsWith(".png") || l.endsWith(".gif")
}

/** Inline indicator next to a toy name. Tells the user at a glance that
 *  a link is a placeholder photo, a notebook, etc. */
private fun toyUrlIcon(toy: ResearchToy): String? {
    val url = toy.url ?: return null
    val l = url.lowercase()
    if (l.endsWith(".jpg") || l.endsWith(".jpeg") || l.endsWith(".png") || l.endsWith(".gif"))
        return "📷"
    if (toy.toy == "Jupyter" || l.contains(".ipynb") || l.contains("colab.research"))
        return "📓"
    if (toy.toy == "Wolfram Alpha" || l.contains("wolframcloud.com") || l.endsWith(".nb"))
        return "✴\uFE0F"
    if (l.contains("github.com")) return "🐙"
    return null
}

// ---------- Project detail ----------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ProjectDetailScreen(
    title: String,
    indexUrl: String,
    onBack: () -> Unit,
    onImageTap: (String) -> Unit,
) {
    var markdown by remember(indexUrl) { mutableStateOf<String?>(null) }
    LaunchedEffect(indexUrl) {
        markdown = runCatching { loadProjectMarkdown(indexUrl) }
            .getOrElse { e -> "# Error\n\n${e.message ?: e::class.simpleName}" }
    }
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(title) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                },
            )
        },
    ) { p ->
        Box(Modifier.padding(p).fillMaxSize()) {
            val md = markdown
            if (md == null) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    androidx.compose.material3.CircularProgressIndicator()
                }
            } else {
                MarkdownWebView(markdown = md, onImageTap = onImageTap)
            }
        }
    }
}

/** Fetch + transform an `index.md` into renderable markdown: strip
 *  front-matter, strip Jekyll templates, resolve relative URLs, inject
 *  photos declared in the front matter. Mirrors iOS ProjectDetailView. */
private suspend fun loadProjectMarkdown(indexUrl: String): String {
    var md = Http.getString(indexUrl)
    // Legacy projects declare photos explicitly; modern projects rely
    // on the Jekyll layout auto-scanning `photos/setup/` +
    // `photos/samples/`. Replicate that by querying the GitHub
    // contents API when the front matter is empty, matching iOS
    // ProjectDetailView.scanProjectPhotos.
    var photos = MarkdownHelper.extractPhotos(md, "photos")
    if (photos.isEmpty()) {
        photos = scanProjectPhotos(indexUrl).shuffled()
    }
    val dataPhotos = MarkdownHelper.extractPhotos(md, "data_photos")
    md = MarkdownHelper.stripFrontMatter(md)
    md = MarkdownHelper.injectPhotos(md, photos)
    md = MarkdownHelper.injectDataPhotos(md, dataPhotos)
    val base = indexUrl.substringBeforeLast('/')
    return MarkdownHelper.resolveRelativeUrls(md, base)
}

@Serializable
private data class GitHubContentEntry(val name: String, val type: String)

private val githubJson = Json { ignoreUnknownKeys = true }

/** Fetch the union of image filenames under a project's
 *  `photos/setup/` and `photos/samples/` via the GitHub contents API.
 *  Returns relative paths (e.g. `photos/setup/setup1.jpeg`) so they
 *  resolve through MarkdownHelper.resolveRelativeUrls. Silent on
 *  failure — photos are decorative; a broken network must not crash
 *  the page. */
private suspend fun scanProjectPhotos(indexUrl: String): List<String> {
    // indexUrl path: /vivianweidai/science/main/research/projects/{folder}/index.md
    val parts = indexUrl.substringAfter("://").substringAfter('/').split('/')
    val idxPos = parts.indexOf("index.md").takeIf { it > 3 } ?: return emptyList()
    val owner = parts[0]
    val repo = parts[1]
    val branch = parts[2]
    // indexUrl segments may already be percent-encoded (the toy's
    // project_url in toys.json carries `%20` for spaces). Decode to raw
    // names before we re-encode them for the GitHub contents API — a
    // double-encode would turn `%20` into `%2520` and the API 404s.
    val folderParts = parts.subList(3, idxPos).map {
        java.net.URLDecoder.decode(it, "UTF-8")
    }

    val all = mutableListOf<String>()
    for (sub in listOf("photos/setup", "photos/samples")) {
        val apiPath = (folderParts + sub.split("/")).joinToString("/") {
            java.net.URLEncoder.encode(it, "UTF-8").replace("+", "%20")
        }
        val url = "https://api.github.com/repos/$owner/$repo/contents/$apiPath?ref=$branch"
        runCatching {
            val body = Http.getString(url)
            val entries = githubJson.decodeFromString<List<GitHubContentEntry>>(body)
            entries.filter { it.type == "file" }.forEach { e ->
                val lower = e.name.lowercase()
                if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") ||
                    lower.endsWith(".png")) {
                    all += "$sub/${e.name}"
                }
            }
        }
        // Failures (404 for projects without one of the subfolders,
        // network blip, rate-limit) are silently skipped.
    }
    return all
}

// ---------- Photo viewer ----------

/// Shared pinch-to-zoom + drag-to-pan viewer used by both Research
/// (toy placeholder photos, in-page images) and Olympiads (activity
/// photos). `internal` so OlympiadsView.kt in the same module can reuse
/// the route target directly. Double-tap toggles between fit and 2.5x.
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun PhotoViewerScreen(title: String, url: String, onBack: () -> Unit) {
    var scale by remember { mutableStateOf(1f) }
    var offset by remember { mutableStateOf(androidx.compose.ui.geometry.Offset.Zero) }
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(title) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                },
            )
        },
    ) { p ->
        Box(
            modifier = Modifier.padding(p).fillMaxSize().padding(16.dp),
            contentAlignment = Alignment.Center,
        ) {
            AsyncImage(
                model = url,
                contentDescription = title,
                modifier = Modifier
                    .fillMaxSize()
                    .clip(RoundedCornerShape(8.dp))
                    .graphicsLayer(
                        scaleX = scale,
                        scaleY = scale,
                        translationX = offset.x,
                        translationY = offset.y,
                    )
                    .pointerInput(Unit) {
                        detectTransformGestures { _, pan, zoom, _ ->
                            scale = (scale * zoom).coerceIn(1f, 6f)
                            offset = if (scale > 1f) offset + pan
                                     else androidx.compose.ui.geometry.Offset.Zero
                        }
                    }
                    .pointerInput(Unit) {
                        detectTapGestures(
                            onDoubleTap = {
                                if (scale > 1f) {
                                    scale = 1f
                                    offset = androidx.compose.ui.geometry.Offset.Zero
                                } else {
                                    scale = 2.5f
                                }
                            },
                        )
                    },
            )
        }
    }
}
