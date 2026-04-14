import SwiftUI

/// Renders a markdown string with KaTeX math via a WKWebView hosting the
/// katex-shell.html bundled with the package.
///
/// Optional `tableName` + `highlightedRows` enable curriculum-specific
/// table rendering: the JS shell will prepend a full-width header row
/// with the table name (matching `.curr-topic-body` on the webapp) and
/// apply a `.highlight` class to the data rows at the given indices.
///
/// On non-UIKit hosts (e.g. `swift build` running on macOS for type-checking)
/// this falls back to a plain SwiftUI stub so call sites can embed it from
/// shared code. The real rendering path is iOS-only.
#if canImport(UIKit)

import UIKit
import WebKit

public struct MarkdownWebView: UIViewRepresentable {
    let markdown: String
    let tableName: String?
    let highlightedRows: [Int]

    public init(markdown: String, tableName: String? = nil, highlightedRows: [Int] = []) {
        self.markdown = markdown
        self.tableName = tableName
        self.highlightedRows = highlightedRows
    }

    public func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.isOpaque = false
        view.backgroundColor = .clear
        view.scrollView.backgroundColor = .clear
        if let url = Bundle.module.url(forResource: "katex-shell", withExtension: "html") {
            view.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        context.coordinator.webView = view
        context.coordinator.pendingOptions = RenderOptions(
            markdown: markdown,
            tableName: tableName,
            highlightedRows: highlightedRows
        )
        view.navigationDelegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.render(
            RenderOptions(
                markdown: markdown,
                tableName: tableName,
                highlightedRows: highlightedRows
            )
        )
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    struct RenderOptions {
        let markdown: String
        let tableName: String?
        let highlightedRows: [Int]
    }

    public final class Coordinator: NSObject, WKNavigationDelegate {
        weak var webView: WKWebView?
        var pendingOptions: RenderOptions?
        var loaded = false

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            loaded = true
            if let pending = pendingOptions {
                render(pending)
            }
        }

        func render(_ options: RenderOptions) {
            guard let view = webView else { return }
            guard loaded else { pendingOptions = options; return }

            var payload: [String: Any] = [
                "markdown": options.markdown,
                "highlightedRows": options.highlightedRows
            ]
            if let tableName = options.tableName {
                payload["tableName"] = tableName
            }

            guard let data = try? JSONSerialization.data(withJSONObject: payload, options: [.fragmentsAllowed]),
                  let json = String(data: data, encoding: .utf8) else {
                return
            }
            view.evaluateJavaScript("window.renderMarkdown(\(json));", completionHandler: nil)
        }
    }
}

#else

/// Host-only stub so `swift build` on macOS type-checks. Never runs in
/// practice — the app is iOS-only.
public struct MarkdownWebView: View {
    let markdown: String
    let tableName: String?
    let highlightedRows: [Int]

    public init(markdown: String, tableName: String? = nil, highlightedRows: [Int] = []) {
        self.markdown = markdown
        self.tableName = tableName
        self.highlightedRows = highlightedRows
    }

    public var body: some View {
        Text("Preview unavailable on this platform")
            .foregroundStyle(.secondary)
            .padding()
    }
}

#endif
