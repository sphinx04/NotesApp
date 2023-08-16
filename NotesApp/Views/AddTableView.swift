//
//  AddTableView.swift
//  NotesApp
//
//  Created by Sphinx04 on 16.08.23.
//

import SwiftUI

struct AddTableView: View {
    @Binding var mdStr: String
    @ObservedObject var dataModel: DataStorageModel
    @Binding var addTable: Bool

    var body: some View {
        VStack {
            if mdStr.isEmpty {
                let selectedString = dataModel.currentText[dataModel.selection]
                DynamicTable(selectedString: String(selectedString)) { str in
                    mdStr = str
                }
            } else {
                Spacer()
                ProgressView()
                    .font(.largeTitle)
                    .onAppear {
                        dataModel.currentText.removeSubrange(dataModel.selection)
                        dataModel.selection = dataModel.selection.lowerBound..<dataModel.selection.lowerBound
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            print("mdstr\n", mdStr)

                            dataModel.currentText.insert(contentsOf: "\n\n\(mdStr)\n\n", at: dataModel.selection.lowerBound)

                            let newUpperBound = dataModel.currentText.index(dataModel.selection.lowerBound, offsetBy: mdStr.count + 4)
                            dataModel.selection = newUpperBound..<newUpperBound

                            mdStr = ""
                            addTable = false
                        }
                    }
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.5)])
    }
}

