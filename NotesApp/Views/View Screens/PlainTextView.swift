//
//  PlainTextView.swift
//  NotesApp
//
//  Created by Sphinx04 on 09.08.23.
//

import SwiftUI
import HighlightedTextEditor

enum Field: Int, CaseIterable {
    case input, filename, exportFile
}

struct PlainTextView: View {
    @EnvironmentObject var realmManager: RealmManager
    @ObservedObject var dataModel: DataStorageModel
    @FocusState private var focusedField: Field?
    @State private var currentText = ""
    @State private var currentName = ""

    var body: some View {
        VStack(spacing: 0) {
            TopBarActionsView(
                exportFile: $dataModel.exportFile,
                renameDocument: $dataModel.renameDocument,
                fileName: $currentName
            )
            .alert("Save file", isPresented: $dataModel.exportFile, actions: {
                
                TextField("File name", text: $currentName)

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
                TextField("Document name", text: $currentName)
                Button("Cancel", action: {})
                Button {
                } label: {
                    Text("Rename").fontWeight(.bold)
                }
            }, message: {
                Text("Please enter document name:")
            })
            .transition(.opacity)
            
            HighlightedTextEditor(text: $currentText, highlightRules: .markdown)
                .onSelectionChange { _ in }
                .focused($focusedField, equals: .input)
                .keyboardToolbar {
                    TextFormatButtons(focusedField: _focusedField)
                }
                .onAppear {
                    print("text editor visible")
                    // dataModel = DataStorageModel()
                    currentName = dataModel.getCurrentName()
                    currentText = dataModel.getCurrentText()
                }
                .onDisappear {
                    print("text editor visible")
                    dataModel.setCurrentName(currentName)
                    dataModel.setCurrentText(currentText)
                    dataModel.objectWillChange.send()
                }
        }
    }
}

#Preview  {
    ContentView()
}
