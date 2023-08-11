//
//  DataStorageModel.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 06.03.23.
//

import Foundation
import SwiftUI
import RealmSwift

class DataStorageModel: ObservableObject {
    @State var realmManager: RealmManager
    @AppStorage("currentDocumentNumber") var currentDocumentNumberStorage: Int = 0

    @Published var savedDocuments = [StoredDocument]()
    @Published var currentDocumentNumber: Int = 0
    @Published var exportFile = false
    @Published var renameDocument = false
    @Published var currentName: String = "name"
//    @Published var currentText: String = "text"
    @Published var isDocumentsHidden: Bool = true
    @Published var isTextFieldHidden: Bool = true
    @Published var isPreviewHidden: Bool = true
    @Published var isShareSheetPresented = false

    init(realmManager: RealmManager) {
        self.realmManager = realmManager
        if realmManager.documents.isEmpty {
//            savedDocumentsStorage.append(Document(name: "test", text: "# Welcome test"))
            realmManager.addDocument(name: "test", text: "# Welcome test")
            self.currentDocumentNumber = 0
        }
        self.savedDocuments = realmManager.documents
//        self.currentText = getCurrentText()
    }

    func addDocument(name: String, text: String) {
//        savedDocuments.append(document)
        realmManager.addDocument(name: name, text: text)
    }

    func addDocument(document: StoredDocument) {
//        savedDocuments.append(document)
        realmManager.addDocument(document: document)
    }

    func removeDocument(id: ObjectId) {
//        savedDocuments.remove(at: savedDocuments.firstIndex(where: {$0 == document})!)
        realmManager.deleteDocument(id: id)
        currentDocumentNumber = 0
    }

    func setCurrentDocument(id: ObjectId) {
        if let number = realmManager.documents.firstIndex(where: {$0.id == id}) {
            currentDocumentNumber = number
            print("Current doc assign \(number)")
        } else {
            print("Current doc assign failed")
        }
    }

    func setCurrentName(_ name: String) {
        currentName = name
//        savedDocuments[currentDocumentNumber].name = name
        realmManager.updateDocument(id: realmManager.documents[currentDocumentNumber].id,
                                    name: name)
    }

    func setCurrentText(_ text: String) {
//        currentText = text
        realmManager.updateDocument(id: realmManager.documents[currentDocumentNumber].id,
                                    text: text)
    }

    func getCurrentName() -> String {
        realmManager.documents[currentDocumentNumber].name
    }

    func getCurrentText() -> String {
        objectWillChange.send()
        print("currentDocumentNumber:", currentDocumentNumber)
        return realmManager.documents[currentDocumentNumber].text
    }

    func getCurrentDocument() -> StoredDocument {
        realmManager.documents[currentDocumentNumber]
    }
}
