//
//  ExportFile.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 28.02.23.
//

import Foundation

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

func saveToPDF(_ str: String, fileName: String) -> URL {
    let url = getDocumentsDirectory().appendingPathComponent("\(fileName).pdf")

    do {
        try str.write(to: url, atomically: true, encoding: .utf8)
        let input = try String(contentsOf: url)
    } catch {
        print(error.localizedDescription)
    }
    return url
}


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
