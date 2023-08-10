//
//  Document.swift
//  NotesApp
//
//  Created by Sphinx04 on 09.08.23.
//

import Foundation

struct Document: Codable, Identifiable {
    var id = UUID()
    var name: String = "Document name"
    var text: String = "# Welcome"
    var lastModified = Date.now

    init(name: String, text: String) {
        self.name = name
        self.text = text
    }

    static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.id      == rhs.id &&
        lhs.name    == rhs.name &&
        lhs.text    == lhs.text
    }
}
