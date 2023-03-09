//
//  DataStorageModel.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 06.03.23.
//

import Foundation
import SwiftUI

class Data: ObservableObject {
    @Published var model: DataStorageModel = DataStorageModel()
    
    func getDocumentsArray() -> [Document] {
        objectWillChange.send()
        return model.savedDocuments
    }
    
    func addDocument(_ document: Document) {
        model.savedDocuments.append(document)
        objectWillChange.send()
    }
    func removeDocument(_ document: Document) {
        model.savedDocuments.remove(at: model.savedDocuments.firstIndex(where: {$0 == document})!)
        model.currentDocumentNumber = 0
        objectWillChange.send()
    }
    
    func setCurrentDocument(_ document: Document) {
        model.currentDocumentNumber = model.savedDocuments.firstIndex(where: {$0 == document})!
        objectWillChange.send()
    }
    
    func resetAppStorage() {
        model.savedDocuments = [Document(name: "test", text: "# Welcome test")]
        model.currentDocumentNumber = 0
    }
    
}

struct DataStorageModel {
    @AppStorage("documents") var savedDocuments: [Document] = [Document(name: "test", text: "# Welcome test")]
    @AppStorage("currentDocumentNumber") var currentDocumentNumber: Int = 0
    
    func getDocumentsArray() -> [Document] {
        savedDocuments
    }
    
    func addDocument(_ document: Document) {
        savedDocuments.append(document)
    }
    func removeDocument(_ document: Document) {
        savedDocuments.remove(at: savedDocuments.firstIndex(where: {$0 == document})!)
        currentDocumentNumber = 0
    }
    
    func setCurrentDocument(_ document: Document) {
        currentDocumentNumber = savedDocuments.firstIndex(where: {$0 == document})!
    }
    
    func resetAppStorage() {
        savedDocuments = [Document(name: "test", text: "# Welcome test")]
        currentDocumentNumber = 0
    }
}
