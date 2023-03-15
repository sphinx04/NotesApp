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
    
    var body: some View {
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
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
            }
            .buttonStyle(.bordered)
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
        TextFormatButtons()
    }
}
