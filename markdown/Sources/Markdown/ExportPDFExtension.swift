//
//  File.swift
//  
//
//  Created by Mnatsakan Zurnadzhian on 03.03.23.
//

import UIKit
import WebKit
import PDFKit

public extension WKWebView {

    /// Exports a PDF document with this web view current contents.
    /// Only call this function when the web view has **finished** loading.
    func exportAsPDF() -> PDFDocument? {
        guard self.isLoading == false else {
            print("WKWebView still loading!")
            return nil
        }
        let pdfData = createPDFData()
        return PDFDocument(data: pdfData)
    }

    private func createPDFData() -> Data {
        let oldBounds = self.bounds

        var printBounds = self.bounds
        printBounds.size.height = scrollView.contentSize.height
        self.bounds = printBounds

        var printableRect = printBounds
        printableRect.origin = .zero

        let printRenderer = UIPrintPageRenderer()
        printRenderer.addPrintFormatter(self.viewPrintFormatter(), startingAtPageAt: 0)
        printRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
        printRenderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")

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
