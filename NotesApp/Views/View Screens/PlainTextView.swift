//
//  PlainTextView.swift
//  NotesApp
//
//  Created by Sphinx04 on 09.08.23.
//

import SwiftUI
import CodeEditor

enum Field: Int, CaseIterable {
    case input, filename, exportFile
}

struct PlainTextView: View {
    @ObservedObject var dataModel: DataStorageModel
    @FocusState private var focusedField: Field?
    @State private var currentText = ""
    
    @State private var currentName = ""
    @State private var fontSize: CGFloat = 14
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        CodeEditor(source: $dataModel.currentText, selection: $dataModel.selection, language: .markdown, theme: .pojoaque)
            .focused($focusedField, equals: .input)
            .keyboardToolbar {
                TextFormatButtons(dataModel: dataModel, focusedField: _focusedField)
                    .background(.thinMaterial)
            }
            .onAppear {
                dataModel.currentName = dataModel.getCurrentName()
                dataModel.currentText = dataModel.getCurrentText()
            }
            .onDisappear {
                dataModel.setCurrentName(dataModel.currentName)
                dataModel.setCurrentText(dataModel.currentText)
                dataModel.objectWillChange.send()
            }
    }
}

struct PlainTextView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
