//
//  SavedDocumentsView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 01.03.23.
//

import SwiftUI



struct Document: Codable, Identifiable {
    var id = UUID()
    var name: String = "Document name"
    var text: String = "# Welcome"
    var lastModified = Date.now
    
    init(name: String, text: String) {
        self.name = name
        self.text = text
    }

    static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.id      == rhs.id &&
        lhs.name    == rhs.name &&
        lhs.text    == lhs.text
    }
}

struct SavedDocumentsView: View {
    
    @State var columnCount: Int = 3
    @Binding var tabSelection: Int
    @State var dataModel = DataStorageModel()
    @State var isSettingsPresented = false
    @State var itemsCount: Int = 0
    
    func createDocument() {
        let name = "Document \(dataModel.getDocumentsArray().count + 1)"
        let text: String = """
        # \(name)
        
        Enter your text here
        
        """
        let document = Document(name: name, text: text)
        
        dataModel.addDocument(document)
        dataModel.setCurrentDocument(document)
        
        tabSelection = 2
        
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
                    createDocument()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            .background(.thickMaterial)
            .zIndex(20)//HSTACK
            
                ScrollView {
                    VStack {
                        LazyVGrid(columns: getColumnsArray(), alignment: .leading) {
                            ForEach(dataModel.getDocumentsArray()) { document in
                                DocumentView(document, fontSizeMultiplyer: 1/Double(columnCount))
                                    .onTapGesture {
                                        dataModel.setCurrentDocument(document)
                                        tabSelection = 2
                                    }
                                    .contextMenu {
                                        Button {
                                            dataModel.addDocument(Document(name: document.name, text: document.text))
                                            dataModel = DataStorageModel()
                                            itemsCount = dataModel.savedDocuments.count
                                        } label: {
                                            Label("Duplicate", systemImage: "doc.on.doc")
                                        }
                                        Button(role: .destructive) {
                                            dataModel.removeDocument(document)
                                            dataModel = DataStorageModel()
                                            itemsCount = dataModel.savedDocuments.count
                                            
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        } // LAZYVGRID
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

struct DocumentView: View {
    
    var document: Document
    var fontSizeMultiplyer: Double
    
    
    init(_ document: Document, fontSizeMultiplyer: Double) {
        self.document = document
        self.fontSizeMultiplyer = fontSizeMultiplyer
    }
    
    func getDateString(from date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        var dateString = ""
        if calendar.isDateInToday(date) {
            dateString = "Today"
        } else if calendar.isDateInYesterday(date) {
            dateString = "Yesterday"
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20 * fontSizeMultiplyer)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                Text(document.text)
                    .padding(30 * fontSizeMultiplyer)
                    .font(.system(size: 15 * fontSizeMultiplyer, weight: .medium))
                    .foregroundColor(.black)
                    .zIndex(80)
            }
            .aspectRatio(3/4, contentMode: .fit)
            .padding([.top, .leading, .trailing])
            
            Text(document.name)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            Text(getDateString(from: document.lastModified))
                .font(.system(size: 10))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .foregroundColor(.secondary)
        }
    }
}


struct SavedDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
