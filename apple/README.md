# Science — Apple Apps

Universal SwiftUI app that mirrors vivianweidai.com across iPhone, iPad,
and Apple Watch. One SwiftPM package (`ScienceCore`) holds all shared
Models, API clients, and Views; the three platform folders are thin
`@main` entry points that pick the appropriate root view.

Three tabs:

- **Curriculum** — flashcard browser for the notes markdown files under
  `/curriculum/{subject}/{section}/{table}.md`. Content is fetched from
  GitHub raw URLs and rendered with KaTeX in a `WKWebView` on iOS/iPadOS.
  Watch shows plain text (no WebKit on watchOS).
- **Olympiads** — contests tracker plus unified textbooks list, read
  from `archives/CONTENT/olympiads.json` (built from
  `olympiads.yml` via `archives/LAYOUT/build_listings.py`).
- **Research** — experimental data projects under `/research/`.

## Layout

```
apple/
├── Package.swift             SwiftPM manifest — platforms: iOS 17, watchOS 10
├── shared/                   ScienceCore library (shared between all three targets)
│   ├── Models/               NoteCard, Manifest, Activity, ResearchProject
│   ├── API/                  APIClient, NotesLoader, ResearchLoader  (Foundation only — compiles on watchOS)
│   ├── Rendering/            MarkdownWebView + katex-shell.html       (gated #if os(iOS))
│   └── Views/
│       ├── RootTabView.swift           iPhone + iPad root  (gated #if os(iOS))
│       ├── CurriculumView.swift        #if os(iOS)
│       ├── OlympiadsView.swift         #if os(iOS)
│       ├── ResearchView.swift          #if os(iOS)
│       └── Watch/
│           ├── WatchRootView.swift           Apple Watch root  (#if os(watchOS))
│           ├── WatchCurriculumView.swift
│           ├── WatchOlympiadsView.swift
│           └── WatchResearchView.swift
├── ios/                      Universal iPhone + iPad target
│   ├── ScienceApp.swift      @main → RootTabView
│   ├── Info.plist            UIDeviceFamily = [1, 2], iPad gets all 4 orientations
│   └── Assets.xcassets/
└── watch/                    Apple Watch target
    ├── ScienceWatchApp.swift @main → WatchRootView
    ├── Info.plist            WKApplication, UIDeviceFamily = [4]
    └── Assets.xcassets/
```

## Building

Open `apple/Package.swift` in Xcode. Because SwiftPM cannot describe iOS
or watchOS app targets directly, create an Xcode project alongside this
package when you're ready to ship:

1. **Science (iPhone/iPad)** — iOS App target
   - Deployment target: iOS 17
   - Supported destinations: iPhone, iPad
   - Source: `apple/ios/ScienceApp.swift`
   - Info.plist: `apple/ios/Info.plist`
   - Dependency: the local `ScienceCore` library from `Package.swift`

2. **Science Watch** — watchOS App target (independent, not a companion)
   - Deployment target: watchOS 10
   - Source: `apple/watch/ScienceWatchApp.swift`
   - Info.plist: `apple/watch/Info.plist` (`WKRunsIndependentlyOfCompanionApp = true`)
   - Dependency: the same `ScienceCore` library

Both targets link the same package, so any fix to a model or loader
propagates to both automatically. All data comes from public GitHub raw
URLs — no auth, no backend, no writes.

## Cross-platform gating cheat sheet

- `#if os(iOS)` — iPhone + iPad code (TabView with Label tabItems,
  `.navigationBarTitleDisplayMode`, `.searchable`, `Picker(.menu)`, etc.)
- `#if os(watchOS)` — Watch-only UI (smaller fonts, no search, no web view)
- `#if os(iOS)` — `MarkdownWebView` uses `UIViewRepresentable` which is
  iOS/iPadOS only (macOS would need `NSViewRepresentable`, watchOS has
  no WebKit)

Shared code (Models, API clients) is plain Foundation and compiles on
every platform without gating.
