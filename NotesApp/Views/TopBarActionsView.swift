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
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        HStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)

                Text(fileName)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal)
            .onTapGesture {
                renameDocument = true
            }
        }
        .frame(height: 60)
        .zIndex(20)
    }
}

struct TopBarActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
