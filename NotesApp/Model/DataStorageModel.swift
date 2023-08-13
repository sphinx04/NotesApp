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

    @Published var currentText = ""
    @Published var currentName = ""

    @Published var exportFile = false
    @Published var renameDocument = false
    @Published var isDocumentsHidden: Bool = true
    @Published var isTextFieldHidden: Bool = true
    @Published var isPreviewHidden: Bool = true
    @Published var isShareSheetPresented = false
    @Published var currentDocumentId: ObjectId

    init(realmManager: RealmManager) {
        currentDocumentId = ObjectId()
        self.realmManager = realmManager
        if self.realmManager.documents.isEmpty {
            //            savedDocumentsStorage.append(Document(name: "test", text: "# Welcome test"))
            let newDoc = Document(value: ["name": "test",
                                                "text": "# Welcome test",
                                                "lastModified": Date.now])

            self.realmManager.addDocument(document: newDoc)
            self.currentDocumentId = newDoc.id
        }
        self.currentDocumentId = self.realmManager.documents[0].id
    }

    func addDocument(name: String, text: String) {
        let newDoc = Document(value: ["name": name,
                                            "text": text,
                                            "lastModified": Date.now])
        realmManager.addDocument(document: newDoc)
        currentDocumentId = newDoc.id
    }

    func addDocument(document: Document) {
        realmManager.addDocument(document: document)
    }

    func removeDocument(id: ObjectId) {
        realmManager.deleteDocument(id: id)
        currentDocumentId = realmManager.documents[0].id
    }

    func setCurrentDocument(id: ObjectId) {
        currentDocumentId = id
    }

    func setCurrentName(_ name: String) {
        currentName = name
        realmManager.updateDocument(id: currentDocumentId, name: name)
    }

    func setCurrentText(_ text: String) {
        currentText = text
        realmManager.updateDocument(id: currentDocumentId, text: text)
    }

    func getCurrentName() -> String {
        return realmManager.getByID(currentDocumentId)?.name ?? "Error"
    }

    func getCurrentText() -> String {
        print("CURRENT TEXT in model (get):", realmManager.getByID(currentDocumentId)?.text ?? "Error")
        return realmManager.getByID(currentDocumentId)?.text ?? "Error"
    }
}
