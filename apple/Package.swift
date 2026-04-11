// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Science",
    platforms: [
        .iOS(.v17),      // iPhone + iPad (universal)
        .watchOS(.v10),  // Apple Watch companion
        .macOS(.v13)     // Host-only floor so `swift build` type-checks the package
    ],
    products: [
        .library(name: "ScienceCore", targets: ["ScienceCore"])
    ],
    targets: [
        .target(
            name: "ScienceCore",
            path: "shared",
            resources: [
                // katex-shell is only needed on iOS — SwiftPM still bundles it
                // on watchOS but the watch app never loads it.
                .process("Rendering/katex-shell.html")
            ]
        )
    ]
)
