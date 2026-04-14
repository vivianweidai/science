// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Science",
    platforms: [
        .iOS(.v17),        // iPhone + iPad (universal)
        .watchOS(.v10),    // Olympiads companion watch app
        .macOS(.v14)       // Host-only floor so `swift build` type-checks
    ],
    products: [
        // Platform-neutral models, API client, and grouping helpers.
        // The watchOS companion depends on this and nothing else.
        .library(name: "ScienceCore",   targets: ["ScienceCore"]),
        // iOS-only rendering + views layered on top of ScienceCore.
        // This is what the iPhone/iPad app imports.
        .library(name: "ScienceCoreUI", targets: ["ScienceCoreUI"]),
    ],
    targets: [
        .target(
            name: "ScienceCore",
            path: "shared/Core"
        ),
        .target(
            name: "ScienceCoreUI",
            dependencies: ["ScienceCore"],
            path: "shared/UI",
            resources: [
                .process("Rendering/katex-shell.html")
            ]
        ),
    ]
)
