import SwiftUI
import WebKit

#if os(OSX)
    import AppKit
    public typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
    import UIKit
    public typealias ViewRepresentable = UIViewRepresentable
#endif

public struct Markdown: ViewRepresentable {

    @Binding var content: String
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.markdownStyle) private var style: MarkdownStyle
    var textDidChanged: ((String) -> Void)?
    var theme: ColorScheme?
    var action: (MarkdownWebView) -> Void

    public init(content: Binding<String>,
                action: @escaping ((MarkdownWebView) -> Void) = { _ in }) {
//        content.wrappedValue = content.wrappedValue.replacingOccurrences(of: """
//                                                                         .markdown-body {
//                                                                           font-size: 8px;
//                                                                         }
//                                                                         """,
//                                                                         with: """
//                                                                         .markdown-body {
//                                                                           font-size: 20px;
//                                                                         }
//                                                                         """)
        self._content = content
        self.action = action
        self.theme = colorScheme
    }
    public init(content: Binding<String>,
                theme: ColorScheme?,
                action: @escaping ((MarkdownWebView) -> Void) = { _ in }) {
        self._content = content
        self.theme = theme
        self.action = action
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(content: $content, colorScheme: colorScheme)
    }
    private func getWebView(context: Context) -> MarkdownWebView {
        let codeView = MarkdownWebView()
        codeView.setContent(content)
        if (style.padding != nil) {
            codeView.setPadding(style.padding!)
        }
        if (style.paddingTop != nil) {
            codeView.setPaddingTop(style.paddingTop!)
        }
        if (style.paddingBottom != nil) {
            codeView.setPaddingBottom(style.paddingBottom!)
        }
        if (style.paddingLeft != nil) {
            codeView.setPaddingLeft(style.paddingLeft!)
        }
        if (style.paddingRight != nil) {
            codeView.setPaddingRight(style.paddingRight!)
        }
        codeView.textDidChanged = { text in
            context.coordinator.set(content: text)
        }
        colorScheme == .dark ? codeView.setTheme(.dark) : codeView.setTheme(.light)
        action(codeView)

        return codeView
    }



    private func updateView(_ webview: MarkdownWebView, context: Context) {
        if context.coordinator.colorScheme != colorScheme {
            colorScheme == .dark ? webview.setTheme(.dark) : webview.setTheme(.light)
            context.coordinator.set(colorScheme: colorScheme)
        }
        if context.coordinator.content != content {
            webview.setContent(content)
        }

    }
    // MARK: macOS
    public func makeNSView(context: Context) -> MarkdownWebView {
        return getWebView(context: context)
    }

    public func updateNSView(_ webview: MarkdownWebView, context: Context) {
        updateView(webview, context: context)
    }
    // MARK: iOS
    public func makeUIView(context: Context) -> MarkdownWebView {
        getWebView(context: context)
    }

    public func updateUIView(_ webview: MarkdownWebView, context: Context) {
        updateView(webview, context: context)
        action(webview)
    }
}

extension View {
    public func markdownStyle(_ markdownStyle: MarkdownStyle) -> some View {
      return environment(\.markdownStyle, markdownStyle)
    }
}

public extension Markdown {
    class Coordinator: NSObject {
        @Binding private(set) var content: String
        private(set) var colorScheme: ColorScheme

        init(content: Binding<String>, colorScheme: ColorScheme) {
            _content = content
            self.colorScheme = colorScheme
        }

        func set(content: String) {
            if self.content != content {
                self.content = content
            }
        }

        func set(colorScheme: ColorScheme) {
            if self.colorScheme != colorScheme {
                self.colorScheme = colorScheme
            }
        }
    }
}

extension EnvironmentValues {
  fileprivate var markdownStyle: MarkdownStyle {
    get { self[MarkdownStyleKey.self] }
    set {
        self[MarkdownStyleKey.self] = newValue
    }
  }
}

private struct MarkdownStyleKey: EnvironmentKey {
  static let defaultValue = MarkdownStyle()
}
