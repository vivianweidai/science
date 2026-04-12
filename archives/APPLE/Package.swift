// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Science",
    platforms: [
        .iOS(.v17),      // iPhone + iPad (universal)
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
                .process("Rendering/katex-shell.html")
            ]
        )
    ]
)
