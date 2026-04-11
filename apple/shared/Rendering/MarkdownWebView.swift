#if os(iOS)
import SwiftUI
import WebKit

/// Renders a markdown string with KaTeX math via a WKWebView hosting the
/// katex-shell.html bundled with the package.
///
/// iOS / iPadOS only. macOS would need `NSViewRepresentable` and watchOS
/// has no WebKit at all — the watch app uses a plain SwiftUI `Text`-based
/// renderer instead.
public struct MarkdownWebView: UIViewRepresentable {
    let markdown: String

    public init(markdown: String) {
        self.markdown = markdown
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
        context.coordinator.pendingMarkdown = markdown
        view.navigationDelegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.render(markdown)
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public final class Coordinator: NSObject, WKNavigationDelegate {
        weak var webView: WKWebView?
        var pendingMarkdown: String?
        var loaded = false

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            loaded = true
            if let md = pendingMarkdown {
                render(md)
            }
        }

        func render(_ markdown: String) {
            guard let view = webView else { return }
            guard loaded else { pendingMarkdown = markdown; return }
            let json = (try? String(
                data: JSONSerialization.data(withJSONObject: [markdown], options: [.fragmentsAllowed]),
                encoding: .utf8
            )) ?? "[\"\"]"
            let escaped = String(json.dropFirst().dropLast())  // remove outer [ ]
            view.evaluateJavaScript("window.renderMarkdown(\(escaped));", completionHandler: nil)
        }
    }
}
#endif
