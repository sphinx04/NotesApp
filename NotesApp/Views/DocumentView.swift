//
//  DocumentView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 13.03.23.
//

import SwiftUI
import Markdown
import CodeEditor

struct DocumentView: View {
    var document: Document
    var fontSizeMultiplyer: Double
    var duplicateAction: () -> Void
    var deleteAction: () -> Void
    var scaleMultiplier = 0.5
    @State private var fontSize: CGFloat = 0.1

    init(_ document: Document,
         fontSizeMultiplyer: Double,
         duplicateAction: @escaping () -> Void,
         deleteAction: @escaping () -> Void) {
        self.document = document
        self.fontSizeMultiplyer = fontSizeMultiplyer
        self.duplicateAction = duplicateAction
        self.deleteAction = deleteAction
    }
    
    func getDateString(from date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        var dateString = ""
        if calendar.isDateInToday(date) {
            dateString = "Today"
        } else if calendar.isDateInYesterday(date) {
            dateString = "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20 * fontSizeMultiplyer)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 20 * fontSizeMultiplyer)
                    .strokeBorder(.black, lineWidth: 0.2)
                    .foregroundColor(.white)
                
                Text(document.text)
                    .padding(30 * fontSizeMultiplyer)
                    .font(.system(size: 15 * fontSizeMultiplyer, weight: .medium))
                    .foregroundColor(.black)
                    .zIndex(80)

            } //ZSTACK
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20 * fontSizeMultiplyer))
            .contextMenu {
                Button {
                    duplicateAction()
                } label: {
                    Label("Duplicate", systemImage: "doc.on.doc")
                }
                Button(role: .destructive) {
                    deleteAction()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            .aspectRatio(3/4, contentMode: .fit)
            .padding([.top, .leading, .trailing])
            
            Text(document.name)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            Text(getDateString(from: document.lastModified))
                .font(.system(size: 10))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .foregroundColor(.secondary)
        }
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
