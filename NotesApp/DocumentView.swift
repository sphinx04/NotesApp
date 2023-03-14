//
//  DocumentView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 13.03.23.
//

import SwiftUI

struct DocumentView: View {
    
    var document: Document
    var fontSizeMultiplyer: Double
    
    
    init(_ document: Document, fontSizeMultiplyer: Double) {
        self.document = document
        self.fontSizeMultiplyer = fontSizeMultiplyer
    }
    
    func getDateString(from date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        var dateString = ""
        if calendar.isDateInToday(date) {
            dateString = "Today"
        } else if calendar.isDateInYesterday(date) {
            dateString = "Yesterday"
        }
        else {
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
                    .shadow(radius: 5)
                
                Text(document.text)
                    .padding(30 * fontSizeMultiplyer)
                    .font(.system(size: 15 * fontSizeMultiplyer, weight: .medium))
                    .foregroundColor(.black)
                    .zIndex(80)
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
