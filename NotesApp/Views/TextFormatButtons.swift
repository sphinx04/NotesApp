//
//  TextFormatButtons.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 15.03.23.
//

import SwiftUI

struct TextFormatButtons: View {

    var inputController = UIInputViewController()
    @State var addImage: Bool = false
    @State var addLink: Bool = false
    @State var imagePlaceholder: String = ""
    @State var linkPlaceholder: String = ""
    @State var imageURL: String = ""
    @State var linkURL: String = ""
    @FocusState var focusedField: Field?

    var body: some View {
            HStack {
                if focusedField == .input {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
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
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                }
                                .padding(.horizontal, 5)
                                
                                Button {
                                    let str = inputController.textDocumentProxy.selectedText
                                    
                                    if let selected = str {
                                        inputController.textDocumentProxy.insertText("**\(selected)**")
                                    }
                                } label: {
                                    Image(systemName: "bold")
                                        .font(.largeTitle)
                                }
                                .buttonStyle(.bordered)
                                .padding(.horizontal, 5)
                                
                                Button {
                                    let str = inputController.textDocumentProxy.selectedText
                                    
                                    if let selected = str {
                                        inputController.textDocumentProxy.insertText("*\(selected)*")
                                    }
                                } label: {
                                    Image(systemName: "italic")
                                        .font(.largeTitle)
                                }
                                .buttonStyle(.bordered)
                                .padding(.horizontal, 5)
                                
                            }
                            
                            SymbolButton(symbol: "`")
                            SymbolButton(symbol: "#")
                            SymbolButton(symbol: "!")
                            SymbolButton(symbol: "[")
                            SymbolButton(symbol: "]")
                            
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
        }
    }

struct TextFormatButtons_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
