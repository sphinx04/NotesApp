//
//  DocumentTabView.swift
//  NotesApp
//
//  Created by Sphinx04 on 25.08.23.
//

import SwiftUI

struct DocumentTabView: View {
    @ObservedObject var dataModel: DataStorageModel
    @State private var tabSelection = 1

    var body: some View {
        VStack(spacing: 0) {
            TopBarActionsView(
                exportFile: $dataModel.exportFile,
                renameDocument: $dataModel.renameDocument,
                fileName: $dataModel.currentName
            )
            .alert("Save file", isPresented: $dataModel.exportFile, actions: {

                TextField("File name", text: $dataModel.currentName)

                Button("Cancel", action: {})

                Button {
                    dataModel.isShareSheetPresented = true
                } label: {
                    Text("Export").fontWeight(.bold)
                }
            }, message: {
                Text("Please enter file name:")
            })
            .alert("Rename document", isPresented: $dataModel.renameDocument, actions: {
                TextField("Document name", text: $dataModel.currentName)
                Button("Cancel", action: {})
                Button {
                } label: {
                    Text("Rename").fontWeight(.bold)
                }
            }, message: {
                Text("Please enter document name:")
            })
            .transition(.opacity)

            TabView(selection: $tabSelection) {
                PlainTextView(dataModel: dataModel)
                    .tabItemViewModifier(label: "Plain text", systemImage: "text.word.spacing")
                    .tag(1)

                PreviewView(dataModel: dataModel)
                    .tabItemViewModifier(label: "Preview", systemImage: "doc.richtext")
                    .tag(2)
            }
            .navigationBarBackButtonHidden()
        } //VSTACK
    }
}

#Preview {
    DocumentTabView(dataModel: DataStorageModel())
}
