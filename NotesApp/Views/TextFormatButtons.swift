//
//  TextFormatButtons.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 15.03.23.
//

import SwiftUI

struct StyleButton: View {

    var str: String
    var trailingStr: String
    var imageSystemName: String
    var inputController: UIInputViewController

    init(with str: String, trailingStr: String? = nil, imageSystemName: String) {
        self.str = str
        self.imageSystemName = imageSystemName
        self.inputController = UIInputViewController()
        if let trailingStr {
            self.trailingStr = trailingStr
        } else {
            self.trailingStr = str
        }
    }

    var body: some View {
        Button {
            let selected = inputController.textDocumentProxy.selectedText

            if let selected {
                inputController.textDocumentProxy.insertText("\(str)\(selected)\(trailingStr)")
            }
        } label: {
            Image(systemName: imageSystemName)
                .font(.largeTitle)
        }
        .buttonStyle(.bordered)
        .padding(.horizontal, 1)
    }
}

struct TextFormatButtons: View {
    
    var inputController = UIInputViewController()
    @ObservedObject var dataModel: DataStorageModel
    @State var addImage: Bool = false
    @State var addLink: Bool = false
    @State var addTable = false
    @State var imagePlaceholder: String = ""
    @State var linkPlaceholder: String = ""
    @State var imageURL: String = ""
    @State var linkURL: String = ""
    @State var mdStr = ""
    @FocusState var focusedField: Field?

    var body: some View {
        HStack {
            if focusedField == .input {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Menu {
                            Button {
                                imagePlaceholder = ""
                                imageURL = ""
                                addImage = true

                            } label: {
                                Text("Add image")
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                            }
                            .buttonStyle(.bordered)
                            .padding(.horizontal, 5)

                            Button {
                                linkPlaceholder = ""
                                linkURL = ""
                                addLink = true
                            } label: {
                                Text("Add link")
                                Image(systemName: "link")
                                    .font(.largeTitle)
                            }
                            .buttonStyle(.bordered)
                            .padding(.horizontal, 5)

                            Button {
                                addTable = true

                            } label: {
                                Text("Add table")
                                Image(systemName: "tablecells")
                                    .font(.largeTitle)
                            }
                            .buttonStyle(.bordered)
                            .padding(.horizontal, 5)

                        } label: {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                        } //MENU
                        .padding(.horizontal, 5)

                        HStack {
                            if !dataModel.selection.isEmpty {
                                StyleButton(with: "**", imageSystemName: "bold")
                                StyleButton(with: "*", imageSystemName: "italic")
                                StyleButton(with: "<u>", trailingStr: "</u>", imageSystemName: "underline")
                                StyleButton(with: "~~", imageSystemName: "strikethrough")
                                
                            }

                            SymbolButton(symbol: "`")
                            SymbolButton(symbol: "#")
                            SymbolButton(symbol: "!")
                            SymbolButton(symbol: "[")
                            SymbolButton(symbol: "]")
                        }
                        Spacer()
                        
                    } // HSTACK
                    .padding(.bottom, 7)
                    .padding(.horizontal, 5)
                    
                }
                .animation(.easeInOut, value: dataModel.selection.isEmpty)

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
        } //HSTACH
        .animation(.easeInOut, value: focusedField)
        .alert("Add link", isPresented: $addLink, actions: {
            TextField("Placeholder", text: $linkPlaceholder)
            TextField("URL", text: $linkURL)
            
            Button("Cancel", action: {})
            
            Button {
                inputController.textDocumentProxy.insertText("[\(linkPlaceholder)](\(linkURL))")
                
            } label: {
                Text("Add").fontWeight(.bold)
            }
        }, message: {
            Text("Please enter placeholder and URL:")
        })
        .alert("Add image", isPresented: $addImage, actions: {
            
            TextField("Placeholder", text: $imagePlaceholder)
            TextField("URL", text: $imageURL)
            
            Button("Cancel", action: {})
            
            Button {
                inputController.textDocumentProxy.insertText("")
                inputController.textDocumentProxy.insertText("![\(imagePlaceholder)](\(imageURL))")
                
            } label: {
                Text("Add").fontWeight(.bold)
            }
        }, message: {
            Text("Please enter placeholder and URL:")
        })
        .sheet(isPresented: $addTable) {
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
}

struct TextFormatButtons_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
