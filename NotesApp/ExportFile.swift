//
//  ExportFile.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 28.02.23.
//

import Foundation
import WebKit

func saveToFile(_ str: String, fileName: String) -> URL {
    let url = getDocumentsDirectory().appendingPathComponent("\(fileName).md")

    do {
        try str.write(to: url, atomically: true, encoding: .utf8)
        let input = try String(contentsOf: url)
    } catch {
        print(error.localizedDescription)
    }
    return url
}

@MainActor func saveToPDF(_ webView: WKWebView, rect: CGRect) -> URL {
    let pdfData = webView.createPDFData(rect: rect)
    
    let url = getDocumentsDirectory().appendingPathComponent("output.pdf")
    
    do {
        try pdfData.write(to: url)
    } catch {
        print(error.localizedDescription)
    }
    
    return url
}


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
