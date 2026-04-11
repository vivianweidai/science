// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Science",
    platforms: [.iOS(.v17)],
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
