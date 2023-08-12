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

    func createDocument() -> Document {
        let name = "Document \(dataModel.realmManager.documents.count + 1)"
        let text: String = """
        # \(name)

        Enter your text here

        """
        return Document(value: ["name": name,
                                             "text": text,
                                             "lastModified": Date.now])
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
                    let name = "Document \(dataModel.realmManager.documents.count + 1)"
                    let text: String = """
                    # \(name)
                    
                    Enter your text here
                    
                    """
                    
                    let newDocument = Document(value: ["name": name,
                                                       "text": text,
                                                       "lastModified": Date.now])
                    
                    dataModel.addDocument(document: newDocument)
                    // dataModel.setCurrentDocument(newDocument)
                    dataModel.setCurrentDocument(id: newDocument.id)
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
                            ForEach(dataModel.realmManager.documents, id: \.id) { document in
                                if !document.isInvalidated {
                                    DocumentView(document, fontSizeMultiplyer: 1/Double(columnCount)) {
                                        // withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                                            dataModel.addDocument(name: "\(document.name)_copy",
                                                                  text: document.text)
                                        // }
                                    } deleteAction: {
                                        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                                            dataModel.removeDocument(id: document.id)
                                        }
                                    }
                                    .onTapGesture {
                                        dataModel.setCurrentDocument(id: document.id)
                                        tabSelection = 2
                                    }
                                }
                            }
                        }  // LAZYVGRID
                        .padding()
                        //.animation(.easeInOut, value: columnCount)
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
