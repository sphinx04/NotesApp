//
//  SavedDocumentsView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 01.03.23.
//

import SwiftUI

struct SavedDocumentsView: View {
    
    @State var columnCount: Int = 3
    @ObservedObject var dataModel: DataStorageModel

    var filteredDocuments: [Document] {
        guard !dataModel.searchText.isEmpty else { return dataModel.documents }
        let array1 = dataModel.documents.filter { document in
            document.name!.lowercased().contains(dataModel.searchText.lowercased())
        }
        let array2 = dataModel.documents.filter { document in
            document.text!.lowercased().contains(dataModel.searchText.lowercased())
        }
        return array1.union(newElements: array2, byKeyPath: \.id)
    }

    var body: some View {
//            SavedDocumentsHeaderView(dataModel: dataModel, columnCount: $columnCount)
            ScrollView {
                VStack {
                    LazyVGrid(columns: getColumnsArray(), alignment: .leading) {
                        ForEach(filteredDocuments, id: \.id) { document in
                                NavigationLink {
                                    DocumentTabView(dataModel: dataModel)
                                        .onAppear {
                                            dataModel.currentDocumentId = document.id!
                                        }
                                } label: {
                                    DocumentView(document, fontSizeMultiplyer: 1/Double(columnCount)) {
                                        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                                            dataModel.addDocument(name: "\(document.name!)_copy",
                                                                  text: document.text!,
                                                                  date: document.lastModified!)
                                        }
                                    } deleteAction: {
                                        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                                            dataModel.removeDocument(id: document.id!)
                                        }
                                    }
                                }
                            }
                    }  // LAZYVGRID
                    
                    .searchable(text: $dataModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                    .padding(.horizontal)
                    .animation(.easeInOut, value: columnCount)
                    .animation(.easeInOut, value: dataModel.searchText)
                    Spacer()
                } // VSTACK
            } // SCROLLVIEW
        .modifier(CustomNavBar(dataModel: dataModel, columnCount: $columnCount))
    }


    func getColumnsArray() -> [GridItem] {
        var gridItems: [GridItem] = []
        for _ in 0..<columnCount {
            gridItems.append(GridItem())
        }
        return gridItems
    }
}

struct SavedDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
