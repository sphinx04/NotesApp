//
//  ContentView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 27.02.23.
//

import SwiftUI
import Markdown
import HighlightedTextEditor

// swiftlint: disable force_try
let betweenUnderscores = try! NSRegularExpression(pattern: "_[^_]+_", options: [])
// swiftlint: enable force_try

struct ContentView: View {
    @ObservedObject var dataModel: DataStorageModel
    @State private var tabSelection = 1

    init() {
        self.dataModel = DataStorageModel(realmManager: RealmManager())
        self.tabSelection = 1
    }

    var body: some View {
        TabView(selection: $tabSelection) {
            DocumentsExplorerView(dataModel: dataModel, tabSelection: $tabSelection)
                .tabItemViewModifier(label: "Saved", systemImage: "folder", isHidden: $dataModel.isDocumentsHidden)
                .tag(1)

            PlainTextView(dataModel: dataModel)
                .tabItemViewModifier(label: "Plain text", systemImage: "text.word.spacing", isHidden: $dataModel.isTextFieldHidden)
                .tag(2)

            PreviewView(dataModel: dataModel)
                .tabItemViewModifier(label: "Preview", systemImage: "doc.richtext", isHidden: $dataModel.isPreviewHidden)
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
