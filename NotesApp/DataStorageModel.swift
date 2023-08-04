//
//  DataStorageModel.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 06.03.23.
//

import Foundation
import SwiftUI

class DataStorageModel: ObservableObject {
    @AppStorage("documents") var savedDocumentsStorage: [Document] = [Document(name: "test", text: "# Welcome test")]
    @AppStorage("currentDocumentNumber") var currentDocumentNumberStorage: Int = 0

    @Published var savedDocuments = [Document]()
    @Published var currentDocumentNumber: Int = 0

    init() {
        self.savedDocuments = savedDocumentsStorage
        self.currentDocumentNumber = currentDocumentNumberStorage
    }

    func refreshStorage() {
        savedDocumentsStorage = savedDocuments
        currentDocumentNumberStorage = currentDocumentNumber
    }

    func getDocumentsArray() -> [Document] {
        savedDocuments
    }

    func addDocument(_ document: Document) {
        savedDocuments.append(document)
        refreshStorage()
    }
    func removeDocument(_ document: Document) {
        savedDocuments.remove(at: savedDocuments.firstIndex(where: {$0 == document})!)
        currentDocumentNumber = 0
        refreshStorage()
    }

    func setCurrentDocument(_ document: Document) {
        currentDocumentNumber = savedDocuments.firstIndex(where: {$0 == document})!
        refreshStorage()
    }

    func resetAppStorage() {
        savedDocuments = [Document(name: "test", text: "# Welcome test")]
        currentDocumentNumber = 0
    }

    func setCurrentName(_ name: String) {
        savedDocuments[currentDocumentNumber].name = name
        refreshStorage()
    }

    func setCurrentText(_ text: String) {
        savedDocuments[currentDocumentNumber].text = text
        refreshStorage()
    }

    func getCurrentName() -> String {
        savedDocuments[currentDocumentNumber].name
    }

    func getCurrentText() -> String {
        savedDocuments[currentDocumentNumber].text
    }

    func getCurrentDocument() -> Document {
        savedDocuments[currentDocumentNumber]
    }
}
