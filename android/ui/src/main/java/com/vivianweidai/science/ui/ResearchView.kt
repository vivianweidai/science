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
import androidx.compose.foundation.layout.height
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
import com.vivianweidai.science.core.model.ResearchToyProject
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
                            onToy = { name ->
                                nav.navigate("toy/${URLEncoder.encode(name, "UTF-8")}")
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
        composable("toy/{name}") { back ->
            val name = back.arguments?.getString("name") ?: ""
            ToyDetailScreen(
                store = store,
                toyName = name,
                onBack = { nav.popBackStack() },
                onProject = { title, url ->
                    val encoded = URLEncoder.encode(url, "UTF-8")
                    nav.navigate("project/${URLEncoder.encode(title, "UTF-8")}/$encoded")
                },
                onPhoto = { title, url ->
                    val encoded = URLEncoder.encode(url, "UTF-8")
                    nav.navigate("photo/${URLEncoder.encode(title, "UTF-8")}/$encoded")
                },
            )
        }
        composable("project/{title}/{url}") { back ->
            val title = back.arguments?.getString("title") ?: ""
            val url = back.arguments?.getString("url") ?: ""
            ProjectDetailScreen(
                store = store,
                title = title,
                indexUrl = url,
                onBack = { nav.popBackStack() },
                onToy = { name ->
                    nav.navigate("toy/${URLEncoder.encode(name, "UTF-8")}")
                },
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
    onToy: (String) -> Unit,
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
            TopicCard(topic, onToy, onPhoto)
        }
    }
}

@Composable
private fun TopicCard(
    topic: ResearchTopic,
    onToy: (String) -> Unit,
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
                    TechnologyBlock(tech, onToy, onPhoto)
                }
            }
        }
    }
}

@Composable
private fun TechnologyBlock(
    tech: ResearchTechnology,
    onToy: (String) -> Unit,
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
            ToyRow(toy, onToy, onPhoto)
            if (i != tech.toys.lastIndex) {
                HorizontalDivider(modifier = Modifier.padding(start = 28.dp))
            }
        }
    }
}

@Composable
private fun ToyRow(
    toy: ResearchToy,
    onToy: (String) -> Unit,
    onPhoto: (String, String) -> Unit,
) {
    val context = LocalContext.current
    val externalUrl = toy.externalUrl
    val hasLink = toy.toyUrl != null || externalUrl != null

    val onClick: (() -> Unit)? = when {
        toy.toyUrl != null -> ({ onToy(toy.toy) })
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
    store: ContentStore,
    title: String,
    indexUrl: String,
    onBack: () -> Unit,
    onToy: (String) -> Unit,
    onImageTap: (String) -> Unit,
) {
    var loaded by remember(indexUrl) { mutableStateOf<ProjectDetail?>(null) }
    LaunchedEffect(indexUrl) {
        loaded = runCatching { loadProjectMarkdown(indexUrl) }
            .getOrElse { e ->
                ProjectDetail(
                    markdown = "# Error\n\n${e.message ?: e::class.simpleName}",
                    toyNames = emptyList(),
                )
            }
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
            val detail = loaded
            if (detail == null) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    androidx.compose.material3.CircularProgressIndicator()
                }
            } else {
                androidx.compose.foundation.lazy.LazyColumn(Modifier.fillMaxSize()) {
                    item {
                        MarkdownWebView(markdown = detail.markdown, onImageTap = onImageTap)
                    }
                    if (detail.toyNames.isNotEmpty()) {
                        item {
                            ProjectTechnologySection(
                                store = store,
                                toyNames = detail.toyNames,
                                onToy = onToy,
                            )
                        }
                    }
                }
            }
        }
    }
}

// ---------- Toy detail ----------

/** Native toy page — renders title, science chip, topic·technology
 *  context, hero image, spec description, and the projects list, all
 *  from `toys.json` data. Replaces the previous markdown-passthrough
 *  approach because most toy `index.md` bodies are empty by design. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ToyDetailScreen(
    store: ContentStore,
    toyName: String,
    onBack: () -> Unit,
    onProject: (String, String) -> Unit,
    onPhoto: (String, String) -> Unit,
) {
    val topics by store.topics.collectAsStateWithLifecycle()
    val resolved = remember(topics, toyName) { store.findToy(toyName) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(toyName) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                },
            )
        },
    ) { p ->
        Box(Modifier.padding(p).fillMaxSize()) {
            if (resolved == null) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    if (topics == null) {
                        androidx.compose.material3.CircularProgressIndicator()
                    } else {
                        Text(
                            "Toy not found.",
                            fontStyle = FontStyle.Italic,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            } else {
                val (topic, tech, toy) = resolved
                LazyColumn(
                    contentPadding = androidx.compose.foundation.layout.PaddingValues(14.dp),
                    verticalArrangement = Arrangement.spacedBy(14.dp),
                ) {
                    toy.heroUrl?.let { url ->
                        item {
                            AsyncImage(
                                model = url,
                                contentDescription = toy.toy,
                                contentScale = androidx.compose.ui.layout.ContentScale.Crop,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(200.dp)
                                    .clip(RoundedCornerShape(8.dp)),
                            )
                        }
                    }
                    item {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(8.dp),
                        ) {
                            Text(toy.toy, fontSize = 22.sp, fontWeight = FontWeight.Bold)
                            SubjectChip(topic.science)
                        }
                    }
                    item {
                        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                            Text(
                                topic.topic,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                            Text("·", color = MaterialTheme.colorScheme.onSurfaceVariant)
                            Text(
                                tech.technology,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    }
                    if (!toy.specs.isNullOrEmpty()) {
                        item { Text("${toy.specs!!}.", fontSize = 14.sp) }
                    }
                    item { HorizontalDivider() }
                    item { Text("Projects", fontSize = 17.sp, fontWeight = FontWeight.Bold) }
                    val projects = toy.projects.orEmpty()
                    if (projects.isEmpty()) {
                        item {
                            Text(
                                "No projects yet.",
                                fontStyle = FontStyle.Italic,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    } else {
                        item {
                            Surface(
                                shape = RoundedCornerShape(8.dp),
                                color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f),
                                border = BorderStroke(1.dp, Color.Black.copy(alpha = 0.08f)),
                            ) {
                                Column {
                                    projects.forEachIndexed { i, p ->
                                        ToyProjectRow(p, onProject, onPhoto)
                                        if (i != projects.lastIndex) HorizontalDivider()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun ToyProjectRow(
    project: ResearchToyProject,
    onProject: (String, String) -> Unit,
    onPhoto: (String, String) -> Unit,
) {
    val context = LocalContext.current
    val onClick: (() -> Unit)? = when {
        project.indexUrl != null -> ({ onProject(project.title, project.indexUrl!!) })
        project.externalUrl != null -> ({
            context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(project.externalUrl!!)))
        })
        else -> null
    }
    val row = @Composable {
        Row(
            verticalAlignment = Alignment.Top,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 12.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.spacedBy(10.dp),
        ) {
            Text(
                formatProjectDate(project.date),
                fontSize = 12.sp,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.width(110.dp),
            )
            Column(Modifier.weight(1f)) {
                Text(
                    project.title,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = if (onClick != null) MaterialTheme.colorScheme.primary
                            else MaterialTheme.colorScheme.onSurface,
                )
                if (project.sciences.isNotEmpty()) {
                    Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                        project.sciences.forEach { SubjectChip(it) }
                    }
                }
            }
        }
    }
    if (onClick != null) Surface(onClick = onClick, color = Color.Transparent) { row() }
    else row()
}

private fun formatProjectDate(iso: String): String {
    // "2026-04-27" → "April 27th 2026"
    val parts = iso.split("-")
    if (parts.size != 3) return iso
    val year = parts[0].toIntOrNull() ?: return iso
    val month = parts[1].toIntOrNull() ?: return iso
    val day = parts[2].toIntOrNull() ?: return iso
    if (month !in 1..12) return iso
    val months = listOf(
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December",
    )
    val suffix = when {
        day % 100 in 11..13 -> "th"
        day % 10 == 1 -> "st"
        day % 10 == 2 -> "nd"
        day % 10 == 3 -> "rd"
        else -> "th"
    }
    return "${months[month - 1]} $day$suffix $year"
}

// ---------- Project Technology section ----------

/** Native rendering of the Technology section for a project page —
 *  replaces the inline `<ul class="updates-list">` HTML that was
 *  shipped in markdown bodies. The list of toys comes from the
 *  project's `toys:` front-matter array; each toy is resolved via
 *  ContentStore for parent topic/technology + specs, and tapping a
 *  row navigates internally to ToyDetailScreen. */
@Composable
private fun ProjectTechnologySection(
    store: ContentStore,
    toyNames: List<String>,
    onToy: (String) -> Unit,
) {
    val topics by store.topics.collectAsStateWithLifecycle()
    val resolved = remember(topics, toyNames) {
        val rank = mapOf(
            "Mathematics" to 0, "Computing" to 1, "Physics" to 2,
            "Chemistry" to 3, "Biology" to 4, "Astronomy" to 5,
        )
        toyNames.mapNotNull { store.findToy(it) }
            .sortedWith(compareBy(
                { rank[it.first.science] ?: Int.MAX_VALUE },
                { it.third.id },
            ))
    }
    if (resolved.isEmpty()) return

    Column(
        modifier = Modifier.padding(horizontal = 14.dp, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Text("Technology", fontSize = 17.sp, fontWeight = FontWeight.Bold)
        Surface(
            shape = RoundedCornerShape(8.dp),
            color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f),
            border = BorderStroke(1.dp, Color.Black.copy(alpha = 0.08f)),
        ) {
            Column {
                resolved.forEachIndexed { i, (topic, tech, toy) ->
                    Surface(
                        onClick = { onToy(toy.toy) },
                        color = Color.Transparent,
                    ) {
                        Row(
                            verticalAlignment = Alignment.Top,
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(horizontal = 12.dp, vertical = 8.dp),
                            horizontalArrangement = Arrangement.spacedBy(10.dp),
                        ) {
                            Text(
                                tech.technology,
                                fontSize = 12.sp,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.width(110.dp),
                            )
                            Column(Modifier.weight(1f)) {
                                Text(
                                    toy.toy,
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.SemiBold,
                                    color = MaterialTheme.colorScheme.primary,
                                )
                                if (!toy.specs.isNullOrEmpty()) {
                                    Text(
                                        toy.specs!!,
                                        fontSize = 12.sp,
                                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                                    )
                                }
                            }
                            SubjectChip(topic.science)
                        }
                    }
                    if (i != resolved.lastIndex) HorizontalDivider()
                }
            }
        }
    }
}

private data class ProjectDetail(val markdown: String, val toyNames: List<String>)

/** Fetch + transform an `index.md` into renderable markdown plus the
 *  project's `toys:` frontmatter array (the source for the native
 *  Technology table). Strips the inline `## Technology … </ul>` block
 *  from the body so it doesn't render twice. */
private suspend fun loadProjectMarkdown(indexUrl: String): ProjectDetail {
    var md = Http.getString(indexUrl)
    var photos = MarkdownHelper.extractPhotos(md, "photos")
    if (photos.isEmpty()) {
        photos = scanProjectPhotos(indexUrl).shuffled()
    }
    val dataPhotos = MarkdownHelper.extractPhotos(md, "data_photos")
    val toyNames = MarkdownHelper.extractPhotos(md, "toys")
    val titleBlock = MarkdownHelper.synthesizeProjectTitle(md)
    md = MarkdownHelper.stripFrontMatter(md)
    md = titleBlock + md
    md = MarkdownHelper.stripTechnologySection(md)
    md = MarkdownHelper.injectPhotos(md, photos)
    md = MarkdownHelper.injectDataPhotos(md, dataPhotos)
    val base = indexUrl.substringBeforeLast('/')
    return ProjectDetail(
        markdown = MarkdownHelper.resolveRelativeUrls(md, base),
        toyNames = toyNames,
    )
}

@Serializable
private data class GitHubContentEntry(val name: String, val type: String)

private val githubJson = Json { ignoreUnknownKeys = true }

/** Fetch the union of image filenames under a project's
 *  `photos/setup/` and `photos/samples/` via the GitHub contents API.
 *  Returns relative paths (e.g. `photos/setup/setup1.jpeg`) so they
 *  resolve through MarkdownHelper.resolveRelativeUrls. Silent on
 *  failure — photos are decorative; a broken network must not crash
 *  the page.
 *
 *  `indexUrl` here is the deployed-site URL
 *  (`https://vivianweidai.com/research/projects/{folder}/index.md`),
 *  not a GitHub raw URL — we fetch markdown over the website. The repo
 *  + branch are hardcoded since this app only ever reads its own repo. */
private suspend fun scanProjectPhotos(indexUrl: String): List<String> {
    val parts = indexUrl.substringAfter("://").substringAfter('/').split('/')
    val idxPos = parts.indexOf("index.md").takeIf { it > 0 } ?: return emptyList()
    // indexUrl segments may already be percent-encoded (the toy's
    // project_url in toys.json carries `%20` for spaces). Decode the
    // folder name to its raw form before re-encoding it for the GitHub
    // contents API — a double-encode would turn `%20` into `%2520` and
    // the API 404s.
    val folder = java.net.URLDecoder.decode(parts[idxPos - 1], "UTF-8")
    // public/ is the on-disk root mapped to the site root; that's
    // what the GitHub Contents API needs to see.
    val folderParts = listOf("public", "research", "projects", folder)

    val all = mutableListOf<String>()
    for (sub in listOf("photos/setup", "photos/samples")) {
        val apiPath = (folderParts + sub.split("/")).joinToString("/") {
            java.net.URLEncoder.encode(it, "UTF-8").replace("+", "%20")
        }
        val url = "https://api.github.com/repos/vivianweidai/science/contents/$apiPath?ref=main"
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
