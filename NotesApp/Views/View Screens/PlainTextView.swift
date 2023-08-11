//
//  PlainTextView.swift
//  NotesApp
//
//  Created by Sphinx04 on 09.08.23.
//

import SwiftUI
import HighlightedTextEditor

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
                fileName: $dataModel.currentName
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
                    if focusedField != .filename {
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    TextFormatButtons()
                                    SymbolButton(symbol: "`")
                                    SymbolButton(symbol: "#")
                                    SymbolButton(symbol: "!")
                                    SymbolButton(symbol: "[")
                                    SymbolButton(symbol: "]")
                                    
                                    Spacer()
                                    
                                } // HSTACK
                                .padding(.bottom, 7)
                                .padding(.horizontal, 5)
                                
                            }
                            
                            if self.focusedField != nil {
                                Button {
                                    self.focusedField = nil
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down.fill")
                                        .font(.title)
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                    }
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
