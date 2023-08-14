//
//  PlainTextView.swift
//  NotesApp
//
//  Created by Sphinx04 on 09.08.23.
//

import SwiftUI
import CodeEditor
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
    @State private var fontSize: CGFloat = 16
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    private let rules: [HighlightRule] = [
        HighlightRule(pattern: betweenUnderscores, formattingRules: [
            TextFormattingRule(fontTraits: [.traitItalic, .traitBold]),
            TextFormattingRule(key: .foregroundColor, value: UIColor.red),
            TextFormattingRule(key: .underlineStyle) { content, range in
                if content.count > 10 { return NSUnderlineStyle.double.rawValue }
                else { return NSUnderlineStyle.single.rawValue }
            }
        ])
    ]

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

            CodeEditor(source: $currentText, language: .markdown, theme: .pojoaque, fontSize: $fontSize)
            //HighlightedTextEditor(text: $currentText, highlightRules: .markdown)

                .focused($focusedField, equals: .input)
                .keyboardToolbar {
                    TextFormatButtons(focusedField: _focusedField)
                }
//                .toolbar {
//                    ToolbarItemGroup(placement: .keyboard) {
//                        TextFormatButtons(focusedField: _focusedField)
//                    }
//                }
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

struct PlainTextView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
