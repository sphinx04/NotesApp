//
//  SumbolButton.swift
//  NotesApp
//
//  Created by Sphinx04 on 10.08.23.
//

import SwiftUI

struct SymbolButton: View {
    let symbol: String

    var body: some View {
        Button(symbol) {
        let inputController = UIInputViewController()
        inputController.textDocumentProxy.insertText(symbol)
    }
    .buttonStyle(.bordered)
    .padding(.horizontal, 5)
    }
}

#if DEBUG
#Preview {
    SymbolButton(symbol: ".")
}
#endif
