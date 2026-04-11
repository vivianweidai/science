# Science — iOS App

SwiftUI app that mirrors vivianweidai.com in three tabs:

- **Curriculum** — flashcard browser for the notes markdown files under
  `/curriculum/{subject}/{section}/{table}.md`. Content is fetched from
  GitHub raw URLs and rendered with KaTeX in a `WKWebView`.
- **Olympiads** — contests tracker plus unified textbooks list, backed
  by the Cloudflare D1 database via `/api/olympiads` and `/api/textbooks`.
- **Research** — experimental data projects under `/research/`.

## Layout

```
apple/
├── Package.swift             SwiftPM manifest (open this in Xcode)
├── shared/
│   ├── Models/               NoteCard, Manifest, Olympiad, Textbook, ResearchProject
│   ├── API/                  APIClient, NotesLoader, ResearchLoader
│   ├── Rendering/            MarkdownWebView + katex-shell.html
│   └── Views/                RootTabView + per-tab screens
└── iphone/
    ├── ScienceApp.swift      @main entry point
    ├── Info.plist
    └── Assets.xcassets/
```

## Building

Open `apple/Package.swift` in Xcode. Pick the `Science` scheme and run on
a simulator or device. The app reads public content from
`https://raw.githubusercontent.com/vivianweidai/science/main/...` and hits
the Cloudflare Function at `https://vivianweidai.com/api/...` for
mutable state.
