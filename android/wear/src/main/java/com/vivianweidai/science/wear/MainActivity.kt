package com.vivianweidai.science.wear

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.wear.compose.material.MaterialTheme

/** Wear OS entry point. Mirrors iOS ScienceWatchApp.swift — a single
 *  scene that shows the olympiads timeline. */
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme { OlympiadsRootView() }
        }
    }
}
