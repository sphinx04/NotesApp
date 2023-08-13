//
//  TabItemViewModifier.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 03.03.23.
//

import SwiftUI

struct TabItemViewModifier: ViewModifier {
    var label: String
    var systemImage: String

    func body(content: Content) -> some View {
        content
            .tabItem {
                Label(label, systemImage: systemImage)
            }
    }
}

extension View {
    func tabItemViewModifier(label: String, systemImage: String) -> some View {
        modifier(TabItemViewModifier(label: label, systemImage: systemImage))
    }
}
