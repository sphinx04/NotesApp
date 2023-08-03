//
//  File.swift
//  
//
//  Created by Mnatsakan Zurnadzhian on 03.03.23.
//

import UIKit
import WebKit
import PDFKit


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

public extension WKWebView {

    func createPDFData(rect: CGRect) -> Data {
        let oldBounds = self.bounds

        var printBounds = self.bounds
        printBounds.size.height = scrollView.contentSize.height
        self.bounds = printBounds

        var printableRect = printBounds
        printableRect.origin = .zero

        let printRenderer = UIPrintPageRenderer()
        printRenderer.addPrintFormatter(self.viewPrintFormatter(), startingAtPageAt: 0)
        printRenderer.setValue(NSValue(cgRect: rect), forKey: "paperRect")
        printRenderer.setValue(NSValue(cgRect: rect), forKey: "printableRect")

        self.bounds = oldBounds
        return printRenderer.generatePDFData()
    }
}

extension UIPrintPageRenderer {

    func generatePDFData() -> Data {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()

        for pdfPage in 0..<self.numberOfPages {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }

        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
}
