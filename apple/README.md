# Science — Apple App

Universal SwiftUI app that mirrors vivianweidai.com on iPhone and iPad.
One SwiftPM package (`ScienceCore`) holds all shared Models, API clients,
and Views; the `ios/` folder is a thin `@main` entry point.

Three tabs:

- **Curriculum** — flashcard browser for the notes markdown files under
  `/curriculum/{subject}/{section}/{table}.md`. Content is fetched from
  GitHub raw URLs and rendered with KaTeX in a `WKWebView`.
- **Olympiads** — contests tracker plus unified textbooks list, read
  from `archives/CONTENT/olympiads.json` (built from
  `olympiads.yml` via `archives/LAYOUT/build_olympiads.py`).
- **Research** — experimental data projects under `/research/`.

## Layout

```
apple/
├── Package.swift             SwiftPM manifest — platform: iOS 17
├── project.yml               XcodeGen spec — regenerate with `xcodegen generate`
├── shared/                   ScienceCore library
│   ├── Models/               NoteCard, Manifest, Activity, ResearchProject
│   ├── API/                  APIClient, NotesLoader, ResearchLoader, MarkdownHelper
│   ├── Rendering/            MarkdownWebView + katex-shell.html
│   └── Views/
│       ├── RootTabView.swift          Root (3-tab TabView)
│       ├── CurriculumView.swift       Flashcard browser
│       ├── OlympiadsView.swift        Contests + textbooks
│       └── ResearchView.swift         Research projects
├── ios/                      iPhone + iPad target
│   ├── ScienceApp.swift      @main → RootTabView
│   └── Assets.xcassets/
```

## Building

Run `xcodegen generate` from this directory to create `Science.xcodeproj`,
then open in Xcode.

- **Deployment target:** iOS 17
- **Supported destinations:** iPhone, iPad
- **Bundle ID:** `com.vivianweidai.science`
- **Dependency:** the local `ScienceCore` library from `Package.swift`

All data comes from public GitHub raw URLs — no auth, no backend, no writes.
