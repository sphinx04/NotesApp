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
            VStack {
                GeometryReader { geometry in
                    VStack {
                        content
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - height)
                }
                toolbarView
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onChange(of: proxy.size.height, perform: { newValue in
                                    height = newValue
                                })
                        }
                    )
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
