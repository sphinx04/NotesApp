//
//  DocumentsExplorerView.swift
//  NotesApp
//
//  Created by Sphinx04 on 09.08.23.
//

import SwiftUI

struct DocumentsExplorerView: View {
    @ObservedObject var dataModel: DataStorageModel
    @Binding var tabSelection: Int

    var body: some View {
        VStack(spacing: 0) {
            if !dataModel.isDocumentsHidden {
                SavedDocumentsView(tabSelection: $tabSelection, dataModel: dataModel)
                    .transition(.opacity)
            }
        }
    }
}
