package com.vivianweidai.science

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.foundation.isSystemInDarkTheme
import com.vivianweidai.science.ui.RootTabView

/** Single-activity host — mirrors iOS ScienceApp.swift which is just
 *  `@main` pointing at RootTabView. */
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Edge-to-edge so the curriculum TopAppBar (tinted with the
        // active subject color) fills the status-bar region too, rather
        // than leaving a black gap above the colored band.
        enableEdgeToEdge()
        setContent { ScienceTheme { RootTabView() } }
    }
}

@Composable
private fun ScienceTheme(content: @Composable () -> Unit) {
    val colors = if (isSystemInDarkTheme()) darkColorScheme() else lightColorScheme()
    MaterialTheme(colorScheme = colors) {
        Surface(color = MaterialTheme.colorScheme.background, content = content)
    }
}
