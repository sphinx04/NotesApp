//
//  ContentView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 27.02.23.
//

import SwiftUI
import Markdown

// swiftlint: disable force_try
let betweenUnderscores = try! NSRegularExpression(pattern: "_[^_]+_", options: [])
// swiftlint: enable force_try


struct ContentView: View {
    @ObservedObject var dataModel: DataStorageModel

    init() {
        self.dataModel = DataStorageModel()
    }

    var body: some View {
        NavigationStack {
            SavedDocumentsView(dataModel: dataModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
