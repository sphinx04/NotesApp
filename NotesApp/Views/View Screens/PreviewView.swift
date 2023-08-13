//
//  PreviewView.swift
//  NotesApp
//
//  Created by Sphinx04 on 09.08.23.
//

import SwiftUI
import Markdown

struct PreviewView: View {
    
    @ObservedObject var dataModel: DataStorageModel
    @State private var currentPreview: Markdown?
    @State private var markdownWebView = MarkdownWebView()
    @State private var isLoading = true
    @State private var currentText = ""

    var body: some View {
        ZStack {
            VStack {
                currentPreview
                    .opacity(isLoading ? 0 : 1)
                ShareLink("Export PDF",
                          item: saveToPDF(markdownWebView.webview,
                                          rect: CGRect(x: 0,
                                                       y: 0,
                                                       width: 595.2 * 2,
                                                       height: 841.8 * 2)))
            }
            if isLoading {
                ProgressView()
                    .font(.largeTitle)
            }
        }
        .onAppear {
            isLoading = true
            currentText = dataModel.getCurrentText()
            currentPreview = Markdown(content: $dataModel.currentText)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                currentPreview = Markdown(content: $dataModel.currentText) { webView in
                    DispatchQueue.main.async {
                        markdownWebView = webView
                        withAnimation {
                            isLoading = false
                            markdownWebView.webview.evaluateJavaScript("document.documentElement.outerHTML.toString()") { html, _ in
                                print(html)
                            }
                        }
                    }
                }
            }
        }
    }
}
