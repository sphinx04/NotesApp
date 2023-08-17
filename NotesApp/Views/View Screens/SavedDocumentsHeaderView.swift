//
//  SavedDocumentsHeaderView.swift
//  NotesApp
//
//  Created by Sphinx04 on 16.08.23.
//

import SwiftUI
import ChatGPTSwift

struct SavedDocumentsHeaderView: View {
    @ObservedObject var dataModel: DataStorageModel
    @State var isSettingsPresented = false
    @State var isSmartAddPresented = false
    @State var smartAddText = ""
    @State var isLoading = false
    @Binding var tabSelection: Int
    @Binding var columnCount: Int

    let api = ChatGPTAPI(apiKey: ApiKeys.chatGPTkey)

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
            
            Button {
                isSmartAddPresented = true
            } label: {
                Image(systemName: "plus.square")
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
        } //SETTINGS SHEET
        .sheet(isPresented: $isSmartAddPresented) {
            if isLoading {
                ProgressView()
                    .font(.largeTitle)
                Text("Please wait...")
                    .font(.largeTitle)
            } else {
                TextEditor(text: $smartAddText)
                    .padding(20)
            }
            Button {
                let text = """
        generate markdown file from following text: \(smartAddText)
        use tables if necessary
        """
                Task {
                    do {
                        isLoading = true
                        let response = try await api.sendMessage(text: text)
                        dataModel.addDocument(name: "Smart Document", text: response)
                        tabSelection = 2
                        isSmartAddPresented = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            } label: {
                Text("Create .md")
            }
        }
    }
}
