//
//  KeyboardToolbar.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 15.03.23.
//

import SwiftUI
import Combine

struct KeyboardToolbar<ToolbarView: View>: ViewModifier {
    @State var  height: CGFloat = 0
    private let toolbarView: ToolbarView
    @State var showContent = false

    init(@ViewBuilder toolbar: () -> ToolbarView) {
        self.toolbarView = toolbar()
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                VStack {
                    content
                }
                toolbarView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension View {
    func keyboardToolbar<T>(@ViewBuilder view: @escaping () -> T) -> some View where T: View {
        modifier(KeyboardToolbar(toolbar: view))
    }
}
