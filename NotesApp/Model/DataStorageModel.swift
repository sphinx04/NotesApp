//
//  DataStorageModel.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 06.03.23.
//

import Foundation
import SwiftUI
import CoreData
import Markdown
import WebKit

final class DataStorageModel: ObservableObject {
    
    private let viewContext = DataController.shared.viewContext
    @Published var documents: [Document] = []
    
    
    @Published var selection: Range<String.Index>
    
    @Published var currentText = ""
    @Published var currentName = ""

    @Published var searchText = ""

    @Published var currentPreview: Markdown = Markdown(content: .constant("init"))
    @Published var exportFile = false
    @Published var renameDocument = false
    @Published var isDocumentsHidden: Bool = true
    @Published var isTextFieldHidden: Bool = true
    @Published var isPreviewHidden: Bool = true
    @Published var isShareSheetPresented = false
    @Published var currentDocumentId: UUID?
    
    init() {
        self.selection = String().startIndex..<String().startIndex
        fetchCompanyData()
        addWelcome()
    }
    
    func fetchCompanyData() {
        let request = NSFetchRequest<Document>(entityName: "Document")
        let sort = NSSortDescriptor(key: #keyPath(Document.lastModified), ascending: false)
        request.sortDescriptors = [sort]
        do {
            documents = try viewContext.fetch(request)
        }catch {
            print("DEBUG: Some error occured while fetching")
        }
    }
    
    func addDocument(name: String, text: String, date: Date = .now) {
        let document = Document(context: viewContext)
        document.id = UUID()
        document.name = name
        document.text = text
        document.lastModified = date
        
        save()
        self.currentDocumentId = document.id
        self.fetchCompanyData()
    }
    
    func save() {
        do {
            try viewContext.save()
            withAnimation {
                fetchCompanyData()
            }
        } catch {
            print("Error saving")
        }
    }
    
    private func addWelcome() {
        if self.documents.isEmpty {
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
            
            addDocument(name: name, text: text)
        }
    }
    
    //    func addDocument(document: Document) {
    //        realmManager.addDocument(document: document)
    //    }
    
    func removeDocument(id: UUID) {
        let index = documents.firstIndex(where: { $0.id == id })
        if let index {
            viewContext.delete(documents[index])
            documents.remove(at: index)
            save()
        }
    }
    
    func setCurrentDocument(id: UUID) {
        currentDocumentId = id
    }
    
    func setCurrentName(_ name: String) {
        currentName = name
        let document = documents.first(where: { $0.id == currentDocumentId })
        document?.name = name
        document?.lastModified = .now
        save()
    }
    
    func setCurrentText(_ text: String) {
        currentText = text
        let document = documents.first(where: { $0.id == currentDocumentId })
        document?.text = text
        document?.lastModified = .now
        save()
    }
    
    func getCurrentName() -> String {
        return documents.first(where: { $0.id == currentDocumentId })?.name ?? "Error"
    }
    
    func getCurrentText() -> String {
        return documents.first(where: { $0.id == currentDocumentId })?.text ?? "Error"
    }
}
