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

    @State private var currentText: String = ""

    var body: some View {
        ZStack {
            if mdWebView.webview.isLoading {
                ProgressView()
                    .font(.largeTitle)
            }
            VStack {
                Markdown(content: $currentText)
                ShareLink("Export PDF",
                          item: saveToPDF(mdWebView.webview,
                                          rect: CGRect(x: 0,
                                                       y: 0,
                                                       width: 595.2 * 2,
                                                       height: 841.8 * 2)))
            }

        }
        .onAppear {
            currentText = dataModel.getCurrentText()
        }
    }
}
