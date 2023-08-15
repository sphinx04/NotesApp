//
//  DynamicTable.swift
//  NotesApp
//
//  Created by Sphinx04 on 15.08.23.
//

import SwiftUI
import MarkdownKit

struct DynamicTable: View {
    @State private var cellData: [[String]] = [
        ["", ""],
        ["", ""],
        ["", ""]
    ]
    @State private var string = """
| Name     | Age | Occupation   |
|----------|-----|--------------|
| John     | 30  | Developer    |
| Jane     | 25  | Designer     |
"""
    @State var fromString: Bool = false

    var completion: ((String) -> Void)

    func parseMarkdownTable(_ markdown: String) {
        cellData.removeAll()

        print(markdown)

        var lines = markdown.split(separator: "\n")

        lines.removeAll(where: {$0.isEmpty})

        print("Lines:")
        if lines.count >= 3 {
            var headerLine = lines[0].split(separator: "|")
            for i in 0..<headerLine.count {
                while headerLine[i].first == " " {
                    headerLine[i] = headerLine[i].dropFirst()
                }
                while headerLine[i].last == " " {
                    headerLine[i] = headerLine[i].dropLast()
                }
            }
            cellData.append(headerLine.map({ String($0) }))

            for i in 2..<lines.count {
                var bodyLine = lines[i].split(separator: "|")
                for i in 0..<bodyLine.count {
                    while bodyLine[i].first == " " {
                        bodyLine[i] = bodyLine[i].dropFirst()
                    }
                    while bodyLine[i].last == " " {
                        bodyLine[i] = bodyLine[i].dropLast()
                    }
                }
                cellData.append(bodyLine.map({ String($0) }))
            }
            print(cellData)


//            let headerCells = headerLine
//                .replacingOccurrences(of: "|", with: "")
//                .split(separator: "|")
//                .map { String($0.trimmingCharacters(in: .whitespaces)) }
//
//            let separatorCells = separatorLine
//                .replacingOccurrences(of: "|", with: "")
//                .split(separator: "|")
//                .map { String($0.trimmingCharacters(in: .whitespaces)) }
//
//            if headerCells.count == separatorCells.count {
//                cellData.append(headerCells)
//
//                for rowIndex in 2..<lines.count {
//                    let dataLine = lines[rowIndex]
//                    let dataCells = dataLine
//                        .replacingOccurrences(of: "|", with: "")
//                        .split(separator: "|")
//                        .map { String($0.trimmingCharacters(in: .whitespaces)) }
//
//                    if dataCells.count == headerCells.count {
//                        cellData.append(dataCells)
//                    }
//                }
//            }
        }
    }
    func generateMarkdownFromCellData() -> String {
        var markdownString = ""
        
        let columnWidths: [Int] = (0..<cellData[0].count).map { columnIndex in
            cellData.map { $0[columnIndex].count }.max() ?? 0
        }
        
        for (rowIndex, row) in cellData.enumerated() {
            markdownString += "|"
            for (columnIndex, width) in columnWidths.enumerated() {
                let cellContent = row[columnIndex].padding(toLength: width == 0 ? 1 : width, withPad: " ", startingAt: 0)
                markdownString += " \(cellContent) |"
            }
            markdownString += "\n"
            
            if rowIndex == 0 {
                markdownString += "|"
                for (_, width) in columnWidths.enumerated() {
                    markdownString += " \(String(repeating: "-", count: width == 0 ? 1 : width)) |"
                }
                markdownString += "\n"
            }
        }
        
        return markdownString
    }

    func addRow() {
        withAnimation {
            cellData.append(Array(repeating: "", count: cellData[0].count))
        }
    }

    func addColumn() {
        withAnimation {
            for rowIndex in 0..<cellData.count {
                cellData[rowIndex].append("")
            }
        }
    }

    func deleteRow(at index: Int) {
        withAnimation {
            cellData.remove(at: index)
        }
    }

    func deleteColumn(at index: Int) {
        withAnimation {
            for rowIndex in 0..<cellData.count {
                cellData[rowIndex].remove(at: index)
            }
        }
    }

    
    var body: some View {
        if fromString {
            VStack {
                TextEditor(text: $string)
                    .monospaced()
                    .padding()
                Button {
                    parseMarkdownTable(string)
                    fromString = false
                } label: {
                    Text("Load")
                }
                .padding()
                .buttonStyle(.borderedProminent)

            }
        } else {
            VStack {
                Spacer()
                
                ScrollView([.horizontal, .vertical]) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            ForEach(0..<cellData.count, id: \.self) { rowIndex in
                                HStack(alignment: .lastTextBaseline) {
                                    if cellData.count > 1 {
                                        Button {
                                            deleteRow(at: rowIndex)
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                        .padding(.horizontal, 5)
                                    }
                                    
                                    ForEach(0..<cellData[rowIndex].count, id: \.self) { columnIndex in
                                        VStack {
                                            if rowIndex == 0 && cellData[rowIndex].count > 1 {
                                                Button {
                                                    deleteColumn(at: columnIndex)
                                                } label: {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.red)
                                                }
                                                .padding(.horizontal, 5)
                                            }
                                            
                                            TextField("Enter text", text: $cellData[rowIndex][columnIndex])
                                                .padding(5)
                                                .background(RoundedRectangle(cornerRadius: 5).fill(.thickMaterial))
                                                .fontWeight(rowIndex == 0 ? .bold : .regular)
                                        }
                                    }
                                }
                            } //FOREACH
                            Button {
                                addRow()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.green)
                            }
                        }
                        Button {
                            addColumn()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        }
                    } //HSTACK
                    .padding()
                } //SCROLLVIEW
            } //VSTACK
            .padding()
            
            Button("Generate .md table") {
                let markdown = generateMarkdownFromCellData()
                completion(markdown)
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }
}

#if DEBUG
#Preview {
    DynamicTable(fromString: true) { str in print(str) }
}
#endif
