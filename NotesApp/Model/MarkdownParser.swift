//
//  MarkdownParser.swift
//  NotesApp
//
//  Created by Sphinx04 on 16.08.23.
//

final class MarkdownParser {
    static func parseMarkdownTable(_ markdown: String) -> [[String]] {
        var cellData = [[String]]()

        var lines = markdown.split(separator: "\n")
        lines.removeAll(where: { $0.isEmpty })

        if lines.count >= 3 {
            let headerLine = parseLine(lines[0])
            cellData.append(headerLine)

            for i in 2..<lines.count {
                let bodyLine = parseLine(lines[i])
                cellData.append(bodyLine)
            }
        }
        return removeRowsWithInsufficientColumns(from: cellData)
    }

    static private func removeRowsWithInsufficientColumns(from array: [[String]]) -> [[String]] {
        let maxColumns = maxColumnCount(array)
        let filteredArray = array.filter { $0.count > maxColumns }
        return filteredArray
    }

    static private func maxColumnCount(_ array: [[String]]) -> Int {
        var maxColumns = 0
        for row in array {
            maxColumns = max(maxColumns, row.count)
        }
        return maxColumns
    }

    static private func parseLine(_ line: Substring) -> [String] {
        var parsedLine: [String] = []
        let cells = line.split(separator: "|")

        for cell in cells {
            let cleanedCell = removeFirstAndLastSpace(cell)
            parsedLine.append(String(cleanedCell))
        }

        return parsedLine
    }

    static private func removeFirstAndLastSpace(_ string: Substring) -> Substring {
        var result = string
        while result.first == " " {
            result = result.dropFirst()
        }
        while result.last == " " {
            result = result.dropLast()
        }
        return result
    }

    static func generateMdTable(from cellData: [[String]]) -> String {
        var markdownString = ""

        let columnWidths = calculateColumnWidths(cellData)

        for (rowIndex, row) in cellData.enumerated() {
            markdownString += generateTableRow(row, columnWidths: columnWidths)

            if rowIndex == 0 {
                markdownString += generateTableSeparator(columnWidths: columnWidths)
            }
        }

        return markdownString
    }

    static private func calculateColumnWidths(_ cellData: [[String]]) -> [Int] {
        return (0..<cellData[0].count).map { columnIndex in
            cellData.map { $0[columnIndex].count }.max() ?? 0
        }
    }

    static private func generateTableRow(_ row: [String], columnWidths: [Int]) -> String {
        var rowString = "|"

        for (columnIndex, width) in columnWidths.enumerated() {
            let cellContent = row[columnIndex].padding(toLength: width == 0 ? 1 : width, withPad: " ", startingAt: 0)
            rowString += " \(cellContent) |"
        }

        rowString += "\n"
        return rowString
    }

    static private func generateTableSeparator(columnWidths: [Int]) -> String {
        var separatorString = "|"

        for (_, width) in columnWidths.enumerated() {
            separatorString += " \(String(repeating: "-", count: width == 0 ? 1 : width)) |"
        }

        separatorString += "\n"
        return separatorString
    }

}
