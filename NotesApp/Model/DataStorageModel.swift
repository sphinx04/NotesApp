//
//  DataStorageModel.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 06.03.23.
//

import Foundation
import SwiftUI
import RealmSwift
import Markdown
import WebKit

class DataStorageModel: ObservableObject {
    @State var realmManager: RealmManager


    @Published var selection: Range<String.Index>

    @Published var currentText = ""
    @Published var currentName = ""

    @Published var currentPreview: Markdown = Markdown(content: .constant("init"))
    @Published var exportFile = false
    @Published var renameDocument = false
    @Published var isDocumentsHidden: Bool = true
    @Published var isTextFieldHidden: Bool = true
    @Published var isPreviewHidden: Bool = true
    @Published var isShareSheetPresented = false
    @Published var currentDocumentId: ObjectId

    init(realmManager: RealmManager) {
        currentDocumentId = ObjectId()
        self.selection = String().endIndex..<String().endIndex
        self.realmManager = realmManager
        if self.realmManager.documents.isEmpty {
            let name = "Welcome"
            let text = #"""
# Welcome to Markdown Editing App!

This document will demonstrate various Markdown abilities supported by our app. Markdown is a lightweight markup language that allows you to format text with simple syntax. Let's get started with some examples:

## 1. Headers

You can create headers using the `#` symbol. The number of `#` symbols denotes the level of the header. For example:

### H3 Header
#### H4 Header

## 2. Text Formatting

You can apply basic text formatting with Markdown:

- *Italic*: Use single asterisks or underscores around the text.
- **Bold**: Use double asterisks or underscores.
- ~~Strikethrough~~: Use double tilde symbols.

## 3. Lists

Unordered lists use hyphens, asterisks, or plus signs:

- Item 1
- Item 2
- Item 3

Ordered lists use numbers:

1. First item
2. Second item
3. Third item

## 4. Links

You can create hyperlinks using the following format:

[OpenAI](https://openai.com)

## 5. Images

To embed an image, use the following syntax:

![Alt text](image_url_here)

## 6. Code Blocks

You can display code blocks using triple backticks:

```python
def greet(name):
    print(f"Hello, {name}!")
```

## 7. Blockquotes

To create a blockquote, use the `>` symbol:

> This is a blockquote. You can use it for citing or emphasizing.

## 8. Horizontal Rule

To add a horizontal rule, use three or more hyphens, asterisks, or underscores:

---

## 9. Tables

Markdown tables can be created as follows:

| Name     | Age | Occupation   |
|----------|-----|--------------|
| John     | 30  | Developer    |
| Jane     | 25  | Designer     |

## 10. Task Lists

You can create task lists using square brackets:

- [x] Task 1
- [ ] Task 2
- [ ] Task 3

## 11. Inline Code

To highlight inline code, use single backticks: `code here`.

"""#

            let newDoc = Document(value: ["name": name,
                                                "text": text,
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
