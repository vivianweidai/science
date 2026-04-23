package com.vivianweidai.science.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.vivianweidai.science.core.ContentStore
import com.vivianweidai.science.core.api.CurriculumLoader
import com.vivianweidai.science.core.model.CurriculumManifest
import com.vivianweidai.science.core.model.CurriculumSection
import com.vivianweidai.science.core.model.CurriculumSubject
import com.vivianweidai.science.core.model.CurriculumTable
import com.vivianweidai.science.core.model.CurriculumTopic

/** Curriculum landing + nested drill-down. Mirrors the webapp at
 *  /curriculum/: Subjects → Sections → Topics → rendered Tables. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CurriculumView(store: ContentStore, modifier: Modifier = Modifier) {
    val manifest by store.manifest.collectAsStateWithLifecycle()
    val error by store.manifestError.collectAsStateWithLifecycle()
    val nav = rememberNavController()

    Scaffold(modifier = modifier) { padding ->
        Box(Modifier.padding(padding)) {
            when {
                manifest != null -> NavHost(
                    navController = nav,
                    startDestination = "subjects",
                ) {
                    composable("subjects") {
                        SubjectList(manifest!!) { slug ->
                            nav.navigate("subject/$slug")
                        }
                    }
                    composable("subject/{slug}") { back ->
                        val slug = back.arguments?.getString("slug") ?: return@composable
                        val subject = manifest!!.subject(slug) ?: return@composable
                        SubjectScreen(
                            subject = subject,
                            onBack = { nav.popBackStack() },
                            onSection = { s -> nav.navigate("section/$slug/${s.slug}") },
                        )
                    }
                    composable("section/{subj}/{sect}") { back ->
                        val subjectSlug = back.arguments?.getString("subj") ?: return@composable
                        val sectionSlug = back.arguments?.getString("sect") ?: return@composable
                        val subject = manifest!!.subject(subjectSlug) ?: return@composable
                        val section = subject.sections.firstOrNull { it.slug == sectionSlug }
                            ?: return@composable
                        SectionScreen(
                            subject = subject,
                            section = section,
                            onBack = { nav.popBackStack() },
                            onSubjectCrumb = {
                                nav.popBackStack(route = "subject/$subjectSlug", inclusive = false)
                            },
                            onTopic = { t ->
                                nav.navigate("topic/$subjectSlug/$sectionSlug/${t.slug}")
                            },
                        )
                    }
                    composable("topic/{subj}/{sect}/{topic}") { back ->
                        val subjectSlug = back.arguments?.getString("subj") ?: return@composable
                        val sectionSlug = back.arguments?.getString("sect") ?: return@composable
                        val topicSlug   = back.arguments?.getString("topic") ?: return@composable
                        val subject = manifest!!.subject(subjectSlug) ?: return@composable
                        val section = subject.sections.firstOrNull { it.slug == sectionSlug }
                            ?: return@composable
                        val topic = section.topics.firstOrNull { it.slug == topicSlug }
                            ?: return@composable
                        TopicScreen(
                            subject = subject,
                            section = section,
                            topic = topic,
                            onBack = { nav.popBackStack() },
                            onSubjectCrumb = {
                                nav.popBackStack(route = "subject/$subjectSlug", inclusive = false)
                            },
                            onSectionCrumb = {
                                nav.popBackStack(
                                    route = "section/$subjectSlug/$sectionSlug",
                                    inclusive = false,
                                )
                            },
                        )
                    }
                }
                error != null -> ErrorState(error!!)
                else -> LoadingState(
                    "Loading curriculum",
                    "Fetching the syllabus manifest from GitHub.",
                )
            }
        }
    }
}

// ---------- Level 1: subjects ----------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun SubjectList(
    manifest: CurriculumManifest,
    onSelect: (String) -> Unit,
) {
    Scaffold(topBar = { TopAppBar(title = { Text("Curriculum") }) }) { p ->
        LazyColumn(
            modifier = Modifier.padding(p).fillMaxSize(),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            items(manifest.subjects, key = { it.slug }) { subject ->
                SubjectRow(subject, onClick = { onSelect(subject.slug) })
            }
        }
    }
}

@Composable
private fun SubjectRow(subject: CurriculumSubject, onClick: () -> Unit) {
    Surface(
        color = SubjectPalette.color(subject.name),
        shape = RoundedCornerShape(10.dp),
        border = androidx.compose.foundation.BorderStroke(1.dp, Color.Black.copy(alpha = 0.08f)),
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 22.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                text = subject.name,
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold,
                color = Color.Black.copy(alpha = 0.82f),
                modifier = Modifier.weight(1f),
            )
            Icon(
                Icons.Filled.ChevronRight,
                contentDescription = null,
                tint = Color.Black.copy(alpha = 0.4f),
            )
        }
    }
}

// ---------- Level 2: sections ----------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun SubjectScreen(
    subject: CurriculumSubject,
    onBack: () -> Unit,
    onSection: (CurriculumSection) -> Unit,
) {
    Scaffold(topBar = { TintedBackAppBar(subject, subject.name, onBack) }) { p ->
        Column(Modifier.padding(p).fillMaxSize()) {
            SubjectBreadcrumb(subject, onSubjectClick = null, trail = emptyList())
            LazyColumn {
                items(subject.sections, key = { it.slug }) { section ->
                    RowItem(
                        title = section.name,
                        onClick = { onSection(section) },
                    )
                    androidx.compose.material3.HorizontalDivider()
                }
            }
        }
    }
}

// ---------- Level 3: topics ----------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun SectionScreen(
    subject: CurriculumSubject,
    section: CurriculumSection,
    onBack: () -> Unit,
    onSubjectCrumb: () -> Unit,
    onTopic: (CurriculumTopic) -> Unit,
) {
    Scaffold(topBar = { TintedBackAppBar(subject, section.name, onBack) }) { p ->
        Column(Modifier.padding(p).fillMaxSize()) {
            SubjectBreadcrumb(
                subject = subject,
                onSubjectClick = onSubjectCrumb,
                trail = listOf(Crumb(section.name, null)),
            )
            LazyColumn {
                items(section.topics, key = { it.slug }) { topic ->
                    RowItem(
                        title = topic.name,
                        subtitle = topic.tables.joinToString(", ") { it.name },
                        onClick = { onTopic(topic) },
                    )
                    androidx.compose.material3.HorizontalDivider()
                }
            }
        }
    }
}

// ---------- Level 4: tables ----------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun TopicScreen(
    subject: CurriculumSubject,
    section: CurriculumSection,
    topic: CurriculumTopic,
    onBack: () -> Unit,
    onSubjectCrumb: () -> Unit,
    onSectionCrumb: () -> Unit,
) {
    Scaffold(topBar = { TintedBackAppBar(subject, topic.name, onBack) }) { p ->
        Column(Modifier.padding(p).fillMaxSize()) {
            SubjectBreadcrumb(
                subject = subject,
                onSubjectClick = onSubjectCrumb,
                trail = listOf(
                    Crumb(section.name, onSectionCrumb),
                    Crumb(topic.name, null),
                ),
            )
            // A regular scrollable Column — not LazyColumn — because every
            // CurriculumTableCard hosts a WebView whose height updates
            // mid-render (markdown → rendered tables). LazyColumn's
            // item-recycling + dynamic-height re-measure causes visible
            // jump while the user is scrolling. A plain scroll container
            // measures once and lets the WebViews grow in place.
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
                    .padding(vertical = 16.dp),
                verticalArrangement = Arrangement.spacedBy(24.dp),
            ) {
                topic.tables.forEach { table ->
                    key(table.path) { CurriculumTableCard(table) }
                }
            }
        }
    }
}

/** One rendered table — fetches its markdown body lazily and hands it
 *  off to [MarkdownWebView] along with the highlighted row indices. */
@Composable
private fun CurriculumTableCard(table: CurriculumTable) {
    var body by remember(table.path) { mutableStateOf<String?>(null) }
    var failed by remember(table.path) { mutableStateOf(false) }

    LaunchedEffect(table.path) {
        runCatching { CurriculumLoader.shared.body(table) }
            .onSuccess { body = it }
            .onFailure { failed = true }
    }

    when {
        body != null -> MarkdownWebView(
            markdown = body!!,
            tableName = table.name,
            highlightedRows = table.highlightedRows,
        )
        failed -> Text(
            text = "Failed to load ${table.name}",
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.fillMaxWidth().padding(16.dp),
        )
        else -> Box(
            modifier = Modifier.fillMaxWidth().padding(24.dp),
            contentAlignment = Alignment.Center,
        ) { androidx.compose.material3.CircularProgressIndicator() }
    }
}

// ---------- Shared pieces ----------

/** Back-button top bar tinted with the active subject's palette color,
 *  so the colored band goes all the way up from the breadcrumb through
 *  to the top of the window. Black-ink content matches the breadcrumb
 *  text styling on all three drill-down levels. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun TintedBackAppBar(
    subject: CurriculumSubject,
    title: String,
    onBack: () -> Unit,
) {
    val ink = Color.Black.copy(alpha = 0.82f)
    TopAppBar(
        title = {
            Text(
                title,
                color = ink,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        },
        navigationIcon = {
            IconButton(onClick = onBack) {
                Icon(
                    Icons.AutoMirrored.Filled.ArrowBack,
                    contentDescription = "Back",
                    tint = ink,
                )
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = SubjectPalette.color(subject.name),
            titleContentColor = ink,
            navigationIconContentColor = ink,
            actionIconContentColor = ink,
        ),
    )
}

@Composable
private fun RowItem(title: String, subtitle: String? = null, onClick: () -> Unit) {
    Surface(onClick = onClick) {
        Column(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 12.dp),
            verticalArrangement = Arrangement.spacedBy(2.dp),
        ) {
            Text(title, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
            if (subtitle != null) Text(
                subtitle,
                fontSize = 12.sp,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
            )
        }
    }
}

/** One breadcrumb segment. `onClick == null` means "current level" —
 *  rendered as plain black ink. Otherwise the label becomes a blue
 *  hyperlink matching the olympiad photo-row link style. */
internal data class Crumb(val label: String, val onClick: (() -> Unit)?)

@Composable
private fun SubjectBreadcrumb(
    subject: CurriculumSubject,
    onSubjectClick: (() -> Unit)?,
    trail: List<Crumb>,
) {
    val linkBlue = Color(0xFF0969DA)
    val ink = Color.Black.copy(alpha = 0.82f)
    val divider = Color.Black.copy(alpha = 0.5f)

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(SubjectPalette.color(subject.name))
            .padding(horizontal = 14.dp, vertical = 10.dp),
        verticalAlignment = Alignment.Top,
    ) {
        CrumbText(
            label = subject.name,
            color = if (onSubjectClick != null) linkBlue else ink,
            bold = true,
            onClick = onSubjectClick,
        )
        trail.forEach { piece ->
            Text(" / ", fontSize = 12.sp, color = divider)
            CrumbText(
                label = piece.label,
                color = if (piece.onClick != null) linkBlue else ink,
                bold = false,
                onClick = piece.onClick,
            )
        }
    }
}

@Composable
private fun CrumbText(
    label: String,
    color: Color,
    bold: Boolean,
    onClick: (() -> Unit)?,
) {
    val modifier = if (onClick != null)
        Modifier.clickable(onClick = onClick)
    else Modifier
    Text(
        text = label,
        fontSize = 12.sp,
        fontWeight = if (bold) FontWeight.SemiBold else FontWeight.Normal,
        color = color,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis,
        modifier = modifier,
    )
}
