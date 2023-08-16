//
//  SavedDocumentsHeaderView.swift
//  NotesApp
//
//  Created by Sphinx04 on 16.08.23.
//

import SwiftUI

struct SavedDocumentsHeaderView: View {
    @ObservedObject var dataModel: DataStorageModel
    @State var isSettingsPresented = false
    @Binding var tabSelection: Int
    @Binding var columnCount: Int

    var body: some View {
        HStack {
            Button {
                isSettingsPresented = true
            } label: {
                Image(systemName: "gear")
                    .font(.largeTitle)
            }
            .padding(.horizontal)
            .padding(.bottom, 5)

            Spacer()

            Button {
                let name = "Document \(dataModel.realmManager.documents.count + 1)"
                let text: String = """
                # \(name)

                Enter your text here

                """

                let newDocument = Document(value: ["name": name,
                                                   "text": text,
                                                   "lastModified": Date.now])

                dataModel.addDocument(document: newDocument)
                dataModel.setCurrentDocument(id: newDocument.id)
                tabSelection = 2

            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
        }
        .background(.thickMaterial)
        .zIndex(20)// HSTACK
        .sheet(isPresented: $isSettingsPresented) {
            VStack {
                HStack {
                    Text("Columns count: ")
                        .fontWeight(.medium)
                        .font(.title)

                    Spacer()

                        Picker("Columns", selection: $columnCount) {
                            ForEach(1...4, id: \.self) { columnCount in
                                Text("\(columnCount)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)

                }
                Spacer()
            }
            .presentationDetents([.fraction(0.2), .height(400), .medium, .large])
            .padding(.horizontal)
        }
    }
}
