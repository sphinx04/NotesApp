//
//  DynamicTable.swift
//  NotesApp
//
//  Created by Sphinx04 on 15.08.23.
//

import SwiftUI
import MarkdownKit


struct DeleteButton: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .padding(.horizontal, 5)
    }
}

struct AddButton: View {
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "plus")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.green)
        }
    }
}

struct DynamicTable: View {
    @State private var cellData: [[String]] = [
        ["", ""],
        ["", ""],
        ["", ""]
    ]

    var selectedString: String = ""

    var completion: ((String) -> Void)
    
    var body: some View {
        VStack {
            VStack {
                ScrollView([.horizontal, .vertical]) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            ForEach(0..<cellData.count, id: \.self) { rowIndex in
                                HStack(alignment: .lastTextBaseline) {
                                    if cellData.count > 1 {
                                        DeleteButton {
                                            cellData.deleteRow(at: rowIndex)
                                        }
                                    }
                                    
                                    ForEach(0..<cellData[rowIndex].count, id: \.self) { columnIndex in
                                        VStack {
                                            if rowIndex == 0 && cellData[rowIndex].count > 1 {
                                                DeleteButton {
                                                    cellData.deleteColumn(at: columnIndex)
                                                }
                                            }
                                            
                                            TextField("Enter text", text: $cellData[rowIndex][columnIndex])
                                                .padding(5)
                                                .background(RoundedRectangle(cornerRadius: 5).fill(.thickMaterial))
                                                .fontWeight(rowIndex == 0 ? .bold : .regular)
                                        }
                                    }
                                }
                            } //FOREACH
                            AddButton {
                                cellData.addRow()
                            }
                        }
                        AddButton {
                            cellData.addColumn()
                        }
                    } //HSTACK
                    .padding()
                } //SCROLLVIEW
            } //VSTACK
            .padding()
            
            Button("Generate .md table") {
                let markdown = MarkdownParser.generateMdTable(from: cellData)
                print("md table:", markdown)
                completion(markdown)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
        }
        .onAppear {
            if !selectedString.isEmpty {
                cellData = MarkdownParser.parseMarkdownTable(selectedString)
            }
        }
    }
}

extension [[String]] {
    mutating func addRow() {
        self.append(Array<String>(repeating: "", count: self[0].count))
    }

    mutating func addColumn() {
        for rowIndex in 0..<self.count {
            self[rowIndex].append("")
        }
    }

    mutating func deleteRow(at index: Int) {
        self.remove(at: index)
    }


    mutating func deleteColumn(at index: Int) {
        for rowIndex in 0..<self.count {
            self[rowIndex].remove(at: index)
        }
    }
}

#if DEBUG
#Preview {
    DynamicTable() { str in print(str) }
}
#endif

