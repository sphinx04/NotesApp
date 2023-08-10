//
//  SavedDocumentsView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 01.03.23.
//

import SwiftUI

struct SavedDocumentsView: View {

    @State var columnCount: Int = 3
    @Binding var tabSelection: Int
    @ObservedObject var dataModel: DataStorageModel
    @State var isSettingsPresented = false
    @State var itemsCount: Int = 0

    func createDocument() -> Document {
        let name = "Document \(dataModel.getDocumentsArray().count + 1)"
        let text: String = """
        # \(name)

        Enter your text here

        """
        return Document(name: name, text: text)
    }

    func getColumnsArray() -> [GridItem] {
        var gridItems: [GridItem] = []
        for _ in 0..<columnCount {
            gridItems.append(GridItem())
        }
        return gridItems
    }

    var body: some View {
        VStack {
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
                    let newDocument = createDocument()
                    dataModel.addDocument(newDocument)
                    dataModel.setCurrentDocument(newDocument)
                    itemsCount = dataModel.savedDocuments.count
                    tabSelection = 2

                } label: {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            .background(.thickMaterial)
            .zIndex(20)// HSTACK

                ScrollView {
                    VStack {
                        LazyVGrid(columns: getColumnsArray(), alignment: .leading) {
                            ForEach(dataModel.savedDocuments) { document in
                                DocumentView(document, fontSizeMultiplyer: 1/Double(columnCount)) {
                                    dataModel.addDocument(Document(name: document.name, text: document.text))
                                    itemsCount = dataModel.savedDocuments.count
                                } deleteAction: {
                                    withAnimation(.linear(duration: 0.2).delay(1)) {
                                        dataModel.removeDocument(document)
                                    }
                                    itemsCount = dataModel.savedDocuments.count
                                }
                                .onTapGesture {
                                    dataModel.setCurrentDocument(document)
                                    tabSelection = 2
                                }
                            }
                        }  // LAZYVGRID
                        .padding()
                        .animation(.easeInOut, value: columnCount)
                    Spacer()
                } // VSTACK
            } // SCROLLVIEW

        }
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

struct SavedDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
