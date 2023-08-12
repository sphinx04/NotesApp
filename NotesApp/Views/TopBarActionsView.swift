//
//  TopBarActionsView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 01.03.23.
//

import SwiftUI
import Markdown
import WebKit

struct TopBarActionsView: View {
    @Binding var exportFile: Bool
    @Binding var renameDocument: Bool
    @Binding var fileName: String

    var body: some View {
        HStack {
            HStack {
                Text(fileName)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)

                Spacer()
            }
            .onTapGesture {
                renameDocument = true
            }
            .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))

            ExportFileButtonView(exportFile: $exportFile)
                .topBarButton()
        }
        .background(.thickMaterial)
        .zIndex(20)
    }
}

struct TopBarActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
