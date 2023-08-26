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
    @State private var isShareSheetPresented = false
//    @State private var shareURL: URL?
    @State private var fontSize = 16
    @State private var HTML = ""

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .bottom) {
                dataModel.currentPreview
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
            } //ZSTACK

            Menu {
                ShareLink(item: saveToPDF(markdownWebView.webview,
                                          rect: CGRect(x: 0, y: 0, width: 595.2 * 2, height: 841.8 * 2),
                                          fileName: dataModel.currentName)) {
                    Text("Export PDF")
                    Image(systemName: "doc.richtext")
                }

                ShareLink(item: saveToFile(dataModel.currentText, fileName: dataModel.currentName, format: ".md")) {
                    Text("Export .md")
                    Image(systemName: "doc.text")
                }

                ShareLink(item: saveToFile(HTML, fileName: dataModel.currentName, format: ".html")) {
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
//            dataModel.currentPreview = Markdown(content: $dataModel.currentText)
            asyncInit()
        }
    }

    func asyncInit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dataModel.currentPreview = Markdown(content: $dataModel.currentText) { webView in
                DispatchQueue.main.async {
                    markdownWebView = webView
                    withAnimation {
                        markdownWebView.webview.evaluateJavaScript("document.documentElement.outerHTML.toString()") { html, _ in
                            HTML = html as! String
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
