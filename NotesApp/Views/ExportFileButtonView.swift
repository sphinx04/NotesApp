//
//  ExportFileButtonView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 01.03.23.
//

import SwiftUI

struct ExportFileButtonView: View {

    @Binding var exportFile: Bool
    var body: some View {
        Button {
            exportFile = true
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.largeTitle)
        }
    }
}
