//
//  RealmManager.swift
//  NotesApp
//
//  Created by Sphinx04 on 11.08.23.
//

import Foundation
import RealmSwift

final class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var documents: [Document] = []

    init() {
        openRealm()
        getDocuments()
    }

    func getByID(_ id: ObjectId) -> Document? {
        documents.first(where: {$0.id == id})
    }

    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)

            Realm.Configuration.defaultConfiguration = config

            localRealm = try Realm()

        } catch {
            print(error.localizedDescription)
        }
    }

    func addDocument(name: String, text: String) {
        do {
            if let localRealm {
                try localRealm.write {
                    let newDocument = Document(value: ["name": name,
                                                             "text": text,
                                                             "lastModified": Date.now])
                    localRealm.add(newDocument)
                    getDocuments()
                }
                print("Document added:", name)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func addDocument(document: Document) {
        do {
            if let localRealm {
                try localRealm.write {
                    localRealm.add(document)
                    getDocuments()
                }
                print("Document added:", document.name)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getDocuments() {
        if let localRealm {
            let allDocuments = localRealm.objects(Document.self).sorted(byKeyPath: "lastModified", ascending: false)
            documents = []
            allDocuments.forEach { document in
                documents.append(document)
            }
            print("Fetched documents:", allDocuments.count)
        }
    }

    func updateDocument(id: ObjectId, name: String? = nil, text: String? = nil) {
        if let localRealm {
            do {
                let documentToUpdate = localRealm.objects(Document.self).filter(NSPredicate(format: "id == %@", id))
                guard !documentToUpdate.isEmpty else { return }

                try localRealm.write {
                    if let name {
                        documentToUpdate[0].name = name
                    }
                    if let text {
                        documentToUpdate[0].text = text
                    }
                    documentToUpdate[0].lastModified = Date.now
                    getDocuments()
                }
                print("Document updated with:", name ?? "unchanged")
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func deleteDocument(id: ObjectId) {
        if let localRealm {
            do {
                let documentToDelete = localRealm.objects(Document.self).filter(NSPredicate(format: "id == %@", id))
                guard !documentToDelete.isEmpty else { return }
                try localRealm.write {
                    localRealm.delete(documentToDelete[0])
                    getDocuments()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
