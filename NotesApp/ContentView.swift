//
//  ContentView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 27.02.23.
//

import SwiftUI
import Markdown
import HighlightedTextEditor

enum Field: Int, CaseIterable {
    case input, filename, exportFile
}
let betweenUnderscores = try! NSRegularExpression(pattern: "_[^_]+_", options: [])

struct ContentView: View {
    
    @ObservedObject var dataModel = DataStorageModel()
    @State var currentName: String = "name"
    @State var currentText: String = "text"
    
    @FocusState private var focusedField: Field?
    
    @State var currentView: Markdown?
    
    @State private var mdStr: String = ""
    
    @State var exportFileName = "name"
    @State private var exportFile = false
    @State private var renameDocument = false
    
    @State private var isShareSheetPresented = false
    
    @State var isDocumentsHidden: Bool = true
    @State var isTextFieldHidden: Bool = true
    @State var isPreviewHidden: Bool = true
    
    @State var tabSelection = 2
    
    
    func symbolButton(_ symbol: String) -> some View {
        Button(symbol) {
            let inputController = UIInputViewController()
            inputController.textDocumentProxy.insertText(symbol)
        }
        .buttonStyle(.bordered)
        .padding(.horizontal, 5)
    }
    
    var body: some View {
        
        TabView(selection: $tabSelection) {
            
            // MARK: - Documents explorer
            
            VStack(spacing: 0) {
                if !isDocumentsHidden {
                    SavedDocumentsView(tabSelection: $tabSelection, dataModel: dataModel)
                        .transition(.opacity)
                }
            }
            .tabItemViewModifier(label: "Saved", systemImage: "folder", isHidden: $isDocumentsHidden)
            .tag(1)
            
            
            VStack(spacing: 0) {
                TopBarActionsView(exportFile: $exportFile, renameDocument: $renameDocument, fileName: $currentName)
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
                    .alert("Rename document", isPresented: $renameDocument, actions: {
                        
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
                
                HighlightedTextEditor(text: $currentText, highlightRules: .markdown)
                    .onSelectionChange { _ in }
                    .focused($focusedField, equals: .input)
                    .keyboardToolbar {
                        if focusedField != .filename {
                            HStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        TextFormatButtons()
                                        symbolButton("`")
                                        symbolButton("#")
                                        symbolButton("!")
                                        symbolButton("[")
                                        symbolButton("]")
                                        
                                        Spacer()
                                        
                                    } // HSTACK
                                    .padding(.bottom, 7)
                                    .padding(.horizontal, 5)
                                    
                                }
                                
                                if self.focusedField != nil {
                                    Button {
                                        self.focusedField = nil
                                    } label: {
                                        Image(systemName: "keyboard.chevron.compact.down.fill")
                                            .font(.title)
                                    }
                                    .padding(.horizontal, 10)
                                }
                            }
                        }
                    }
            }
            .onAppear {
                print("text editor visible")
                // dataModel = DataStorageModel()
                dataModel.refreshStorage()
                currentName = dataModel.getCurrentName()
                currentText = dataModel.getCurrentText()
            }
            .onDisappear {
                print("text editor visible")
                dataModel.setCurrentName(currentName)
                dataModel.setCurrentText(currentText)
                
            }
            .tabItemViewModifier(label: "Plain text", systemImage: "text.word.spacing", isHidden: $isTextFieldHidden)
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheetView(activityItems: [saveToFile(mdStr, fileName: exportFileName)])
            }
            .tag(2)
            
            
            VStack {
                if !isPreviewHidden {
                    GeometryReader { proxy in
                        VStack {
                            currentView
                            ShareLink("Export PDF", item: saveToPDF(mdWebView.webview, rect: CGRect(x: 0, y: 0, width: 1000, height: 2000)))
                        }
                    }
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
