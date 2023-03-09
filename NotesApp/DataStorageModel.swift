//
//  DataStorageModel.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 06.03.23.
//

import Foundation
import SwiftUI

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
    
    func setCurrentName(_ name: String) {
        savedDocuments[currentDocumentNumber].name = name
    }
    
    func setCurrentText(_ text: String) {
        savedDocuments[currentDocumentNumber].text = text
    }
    
    func getCurrentName() -> String {
        savedDocuments[currentDocumentNumber].name
    }
    
    func getCurrentText() -> String {
        savedDocuments[currentDocumentNumber].text
    }
}
