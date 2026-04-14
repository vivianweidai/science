import SwiftUI

/// Renders a markdown string with KaTeX math via a WKWebView hosting the
/// katex-shell.html bundled with the package.
///
/// Optional `tableName` + `highlightedRows` enable curriculum-specific
/// table rendering: the JS shell will prepend a full-width header row
/// with the table name, remove the original column-header row, merge
/// identical first-column cells into rowspans, and apply `.highlight` to
/// data rows by index.
///
/// The view sizes itself to the rendered content via a WKScriptMessage
/// channel (`contentHeight`) — katex-shell.html posts
/// `document.body.scrollHeight` after each render and SwiftUI frames the
/// outer view to that height. Internal WebKit scrolling is disabled so
/// multiple tables on one screen flow naturally inside an outer
/// ScrollView without competing scroll gestures.
///
/// On hosts without WebKit (watchOS, and `swift build` running on
/// macOS host-only for type-checking) this falls back to a plain
/// SwiftUI stub so call sites can embed it from shared code. The
/// real rendering path is iOS-only. The guard is `canImport(WebKit)`
/// rather than `canImport(UIKit)` because watchOS has UIKit but NOT
/// WebKit — the narrower check is what lets `ScienceCoreUI` compile
/// cleanly for the watchOS slice of the package.
#if canImport(WebKit)

import UIKit
import WebKit

public struct MarkdownWebView: View {
    let markdown: String
    let tableName: String?
    let highlightedRows: [Int]

    @State private var contentHeight: CGFloat = 80

    public init(markdown: String, tableName: String? = nil, highlightedRows: [Int] = []) {
        self.markdown = markdown
        self.tableName = tableName
        self.highlightedRows = highlightedRows
    }

    public var body: some View {
        MarkdownWebViewRep(
            markdown: markdown,
            tableName: tableName,
            highlightedRows: highlightedRows,
            contentHeight: $contentHeight
        )
        .frame(height: contentHeight)
    }
}

private struct MarkdownWebViewRep: UIViewRepresentable {
    let markdown: String
    let tableName: String?
    let highlightedRows: [Int]
    @Binding var contentHeight: CGFloat

    struct RenderOptions {
        let markdown: String
        let tableName: String?
        let highlightedRows: [Int]
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        // JS → Swift bridge: katex-shell.html posts scrollHeight here
        // after each render so we can size the outer SwiftUI frame.
        config.userContentController.add(context.coordinator, name: "contentHeight")

        let view = WKWebView(frame: .zero, configuration: config)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.scrollView.backgroundColor = .clear
        // Disable internal scrolling — the SwiftUI parent ScrollView owns
        // the scroll gesture, and the webview sizes itself to the
        // contentHeight binding so nothing is clipped.
        view.scrollView.isScrollEnabled = false
        view.scrollView.bounces = false

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

    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.render(
            RenderOptions(
                markdown: markdown,
                tableName: tableName,
                highlightedRows: highlightedRows
            )
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(contentHeight: $contentHeight)
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        weak var webView: WKWebView?
        var pendingOptions: RenderOptions?
        var loaded = false
        var contentHeight: Binding<CGFloat>

        init(contentHeight: Binding<CGFloat>) {
            self.contentHeight = contentHeight
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            loaded = true
            if let pending = pendingOptions {
                render(pending)
            }
        }

        /// Called by katex-shell.html via
        /// `window.webkit.messageHandlers.contentHeight.postMessage(...)`
        /// at the end of every render. Pushes the new height into the
        /// SwiftUI @State binding so the view frame updates.
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard message.name == "contentHeight" else { return }
            if let number = message.body as? NSNumber {
                let height = CGFloat(truncating: number)
                if height > 0 {
                    DispatchQueue.main.async {
                        self.contentHeight.wrappedValue = height
                    }
                }
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
