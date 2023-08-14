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
    @State private var markdownWebView = MarkdownWebView()
    @State private var isLoading = true
//    @State private var currentText = ""
    @State private var isShareSheetPresented = false
    @State private var shareURL: URL?
    @State private var fontSize = 16
    @State private var HTML = ""

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        Spacer()
                        HStack {
                            Button {
                                withAnimation {
                                    if fontSize > 8 {
                                        fontSize -= 1
                                    }
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Font size:", selection: $fontSize) {
                                ForEach(0..<73) { value in
                                    if value >= 8 {
                                        Text(String(value))
                                    }
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100)
                            .onChange(of: fontSize) { _ in
                                markdownWebView.webview.changeFontSize(to: fontSize)
                            }
                            
                            Button {
                                withAnimation {
                                    if fontSize < 72 {
                                        fontSize += 1
                                    }
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                    
                    dataModel.currentPreview
                        .opacity(isLoading ? 0 : 1)
                }
                if isLoading {
                    ProgressView()
                        .font(.largeTitle)
                }
            } //ZSTACK

            Menu {
                ShareLink(item: shareURL ?? URL(fileURLWithPath: "")) {
                    Text("Export PDF")
                    Image(systemName: "doc.richtext")
                }

                ShareLink(item: saveToFile(dataModel.currentText, fileName: "output", format: ".md")) {
                    Text("Export .md")
                    Image(systemName: "doc.text")
                }

                ShareLink(item: saveToFile(HTML, fileName: "output", format: ".html")) {
                    Text("Export HTML")
                    Image(systemName: "square")
                }
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.largeTitle)
            }
            .padding()
            .buttonStyle(.bordered)
        }
        
        .onAppear {
            isLoading = true
            dataModel.currentPreview = Markdown(content: $dataModel.currentText)
            asyncInit()
        }
    }

    func asyncInit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dataModel.currentPreview = Markdown(content: $dataModel.currentText) { webView in
                DispatchQueue.main.async {
                    markdownWebView = webView
                    withAnimation {
                        isLoading = false
                        markdownWebView.webview.evaluateJavaScript("document.documentElement.outerHTML.toString()") { html, _ in
                            HTML = html as! String
                            let rect = CGRect(x: 0, y: 0, width: 595.2 * 2, height: 841.8 * 2)
                            shareURL = saveToPDF(markdownWebView.webview,
                                            rect: rect)
                            markdownWebView.webview.changeFontSize(to: fontSize)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
