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
        Button {
            let inputController = UIInputViewController()
            inputController.textDocumentProxy.insertText(symbol)
        } label: {
            Text(symbol)
                .font(.largeTitle)
        }
        .buttonStyle(.bordered)
        .padding(.horizontal, 1)
    }
}

#if DEBUG
#Preview {
    SymbolButton(symbol: ".")
}
#endif
