//
//  StoredDocument.swift
//  NotesApp
//
//  Created by Sphinx04 on 11.08.23.
//

import Foundation
import RealmSwift

final class StoredDocument: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = "Document name"
    @Persisted var text: String = "# Welcome"
    @Persisted var lastModified = Date.now
}
