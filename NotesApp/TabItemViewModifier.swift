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
    @Binding var isHidden: Bool
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                Label(label, systemImage: systemImage)
            }
            .onAppear {
                withAnimation {
                    isHidden = false
                }
            }
            .onDisappear {
                isHidden = true
            }
    }
}

extension View {
    func tabItemViewModifier(label: String, systemImage: String, isHidden: Binding<Bool>) -> some View {
        modifier(TabItemViewModifier(label: label, systemImage: systemImage, isHidden: isHidden))
    }
}
