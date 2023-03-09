//
//  ContentView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 27.02.23.
//

import SwiftUI
import Markdown

enum Field: Int, CaseIterable {
    case input, filename, exportFile
}

struct ContentView: View {
    @AppStorage("documents", store: .standard) var savedDocuments: [Document] = [Document(name: "test", text: "# Welcome test")]
    
    @AppStorage("currentDocumentNumber") var currentDocumentNumber: Int = 0
    
    @State var currentName: String = "name"
    @State var currentText: String = "text"
    
    @FocusState private var focusedField: Field?
    
    @State var currentView: Markdown?
    
    @State private var mdStr: String = ""
    
    @State var exportFileName = "name"
    @State private var exportFile = false
    
    @State private var isShareSheetPresented = false
    
    @State var isDocumentsHidden: Bool = true
    @State var isTextFieldHidden: Bool = true
    @State var isPreviewHidden: Bool = true
    
    @State var tabSelection = 1
    
    
    var body: some View {
        
        TabView(selection: $tabSelection) {
            
            // MARK: - Documents explorer
            
            VStack(spacing: 0) {
                if !isDocumentsHidden {
                    SavedDocumentsView(tabSelection: $tabSelection)
                        .transition(.opacity)
                }
            }
            .tabItemViewModifier(label: "Saved", systemImage: "folder", isHidden: $isDocumentsHidden)
            .tag(1)
            
            
            VStack(spacing: 0) {
                if !isTextFieldHidden {
                    TopBarActionsView(exportFile: $exportFile, fileName: $currentName)
                        .alert("Save file", isPresented: $exportFile, actions: {
                            
                            TextField("File name", text: $currentName)
                            
                            Button("Cancel", action: {})
                            
                            Button {
                                isShareSheetPresented = true
                            } label: {
                                Text("Export").fontWeight(.bold)
                            }
                        }, message: {
                            Text("Please enter file name:")
                        })
                    
                    TextEditor(text: $currentText)
                        .focused($focusedField, equals: .input)
                        .transition(.opacity)
                }
            }
            .onAppear {
                print("text editor visible")
                currentName = savedDocuments[currentDocumentNumber].name
                currentText = savedDocuments[currentDocumentNumber].text
            }
            .onDisappear {
                print("text editor visible")
                savedDocuments[currentDocumentNumber].name = currentName
                savedDocuments[currentDocumentNumber].text = currentText
                
            }
            .tabItemViewModifier(label: "Plain text", systemImage: "text.word.spacing", isHidden: $isTextFieldHidden)
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheetView(activityItems: [saveToFile(mdStr, fileName: exportFileName)])
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("`") {
                        
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .tag(2)
            
            
            VStack {
                if !isPreviewHidden {
                    currentView
                    
//                    PDFViewDisplay {
//                        currentView
//                    }
                }
            }
            .tabItemViewModifier(label: "Preview", systemImage: "doc.richtext", isHidden: $isPreviewHidden)
            
            .tag(3)
        }
        .onAppear {
            currentView = Markdown(content: $currentText)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
