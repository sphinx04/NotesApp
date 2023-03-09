//
//  TopBarButtonModifier.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 01.03.23.
//

import SwiftUI

struct TopBarButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.bottom, 5)
            .zIndex(10)
    }
}

extension View {
    func topBarButton() -> some View {
        modifier(TopBarButton())
    }
}
