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

        let contectWidth = Int(rect.width * 0.9)
        let contectHeight = Int(rect.height * 0.9)
        let contentX = (Int(rect.width) - contectWidth) / 2
        let contentY = (Int(rect.height) - contectHeight) / 2

        let contentRect = CGRect(x: contentX,
                           y: contentY,
                           width: contectWidth,
                           height: contectHeight)

        let printRenderer = UIPrintPageRenderer()
        printRenderer.addPrintFormatter(self.viewPrintFormatter(), startingAtPageAt: 0)
        printRenderer.setValue(NSValue(cgRect: rect), forKey: "paperRect")
        printRenderer.setValue(NSValue(cgRect: contentRect), forKey: "printableRect")

        self.bounds = oldBounds
        return printRenderer.generatePDFData()
    }

    func changeFontSize(to fontSize: Int, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        let cssString = ".markdown-body { font-size: \(fontSize)px; }"
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        self.evaluateJavaScript(jsString, completionHandler: completionHandler)
    }
}

extension UIPrintPageRenderer {

    func generatePDFData() -> Data {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSRange(location: 0, length: self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()

        for pdfPage in 0..<self.numberOfPages {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }

        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
}
