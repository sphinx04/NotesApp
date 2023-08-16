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

    var selectedString: String = ""

    var completion: ((String) -> Void)

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
        cellData.remove(at: index)
    }


    func deleteColumn(at index: Int) {
        withAnimation {
            for rowIndex in 0..<cellData.count {
                cellData[rowIndex].remove(at: index)
            }
        }
    }

    
    var body: some View {
        VStack {
            VStack {
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

#if DEBUG
#Preview {
    DynamicTable() { str in print(str) }
}
#endif
