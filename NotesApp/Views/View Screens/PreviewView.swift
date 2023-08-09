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
    @State private var currentView: Markdown?

    @State var currentText: String

    var body: some View {
        VStack {
            GeometryReader { _ in
                VStack {
                    currentView
                    ShareLink("Export PDF",
                              item: saveToPDF(mdWebView.webview,
                                              rect: CGRect(x: 0,
                                                           y: 0,
                                                           width: 595.2 * 2,
                                                           height: 841.8 * 2)))
                }
            }
        }
        .onAppear {
            currentText = dataModel.getCurrentText()
            currentView = Markdown(content: $currentText)
        }
    }
}
