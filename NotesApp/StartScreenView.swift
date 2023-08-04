//
//  StartScreenView.swift
//  NotesApp
//
//  Created by Mnatsakan Zurnadzhian on 07.03.23.
//

import SwiftUI

struct StartScreenView: View {

    var textColor = Color(red: 0.4, green: 0.4, blue: 0.4)
    @State var isStatic: Bool = true
    @State var isActive: Bool = false

    var body: some View {
            VStack {
                if !isActive {
                ZStack {
                    // Color(.gray).ignoresSafeArea()
                    ZStack(alignment: .top) {
                        Image("iconBackground")
                            .resizable()
                            .frame(width: 256, height: 256)
                            .shadow(radius: isStatic ? 0 : 20)
                        VStack {

                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: isStatic ? 5 : 10)
                                    .frame(width: isStatic ? 80 : 100, height: isStatic ? 10 : 20)
                                    .shadow(radius: isStatic ? 0 : 6)
                                    .foregroundColor(textColor)

                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: isStatic ? 90 : 70, height: 10)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 25)

                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 50, height: 10)
                                    .foregroundColor(textColor)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 120, height: 10)
                                    .foregroundColor(isStatic ? textColor : Color(red: 0.7, green: 0, blue: 0))
                            }
                            .shadow(radius: isStatic ? 0 : 6)

                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 30, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 15, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 60, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 20, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 15, height: 10)
                            }
                            .foregroundColor(textColor)
                            .shadow(radius: isStatic ? 0 : 6)

                            ZStack {
                                RoundedRectangle(cornerRadius: isStatic ? 5 : 20)
                                    .frame(width: isStatic ? 180 : 100, height: isStatic ? 10 : 80)
                                    .opacity(isStatic ? 1 : 0)
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: isStatic ? 180 : 100, height: isStatic ? 10 : 80)
                                    .opacity(isStatic ? 0 : 1)
                            }
                            .foregroundColor(isStatic ? textColor : Color(red: 0, green: 0, blue: 0.7))
                            .shadow(radius: isStatic ? 0 : 6)

                            HStack(spacing: isStatic ? 10 : 5) {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 35, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 20, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 15, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 50, height: 10)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 20, height: 10)
                            }
                            .shadow(radius: isStatic ? 0 : 6)
                            .foregroundColor(textColor)

                            VStack {
                                HStack(spacing: isStatic ? 10 : 5) {
                                    RoundedRectangle(cornerRadius: isStatic ? 5 : 3)
                                        .frame(width: isStatic ? 100 : 85, height: isStatic ? 10 : 6)
                                    RoundedRectangle(cornerRadius: isStatic ? 5 : 3)
                                        .frame(width: 70, height: isStatic ? 10 : 6)
                                }
                                HStack(spacing: isStatic ? 10 : 5) {
                                    RoundedRectangle(cornerRadius: isStatic ? 5 : 3)
                                        .frame(width: 15, height: isStatic ? 10 : 6)
                                    RoundedRectangle(cornerRadius: isStatic ? 5 : 3)
                                        .frame(width: 40, height: isStatic ? 10 : 6)
                                    RoundedRectangle(cornerRadius: isStatic ? 5 : 3)
                                        .frame(width: 35, height: isStatic ? 10 : 6)
                                    RoundedRectangle(cornerRadius: isStatic ? 5 : 3)
                                        .frame(width: 30, height: isStatic ? 10 : 6)
                                    RoundedRectangle(cornerRadius: isStatic ? 5 : 3)
                                        .frame(width: 20, height: isStatic ? 10 : 6)
                                }
                            } // VSTACK
                            .foregroundColor(isStatic ? textColor : .brown)
                            .padding(.vertical, isStatic ? 0 : 10)
                            .padding(.horizontal, isStatic ? 0 : 10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .opacity(isStatic ? 0 : 0.2)
                                    .foregroundColor(.orange)
                            }
                            .shadow(radius: isStatic ? 0 : 6)

                            VStack(spacing: isStatic ? 8 : -10) {
                                HStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 30, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 60, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 20, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)
                                }

                                HStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 20, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 30, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 60, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)
                                }

                                HStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 30, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 60, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 70, height: 10)
                                }

                                HStack(spacing: 10) {

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 60, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 20, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 30, height: 10)
                                }

                                HStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 30, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 20, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 60, height: 10)

                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 15, height: 10)
                                }

                            }
                            .foregroundColor(isStatic ? textColor : .white)
                        }
                    } // ZSTACK
                    .frame(width: 256, height: 256)
                } // ZSTACK
                .animation(.easeInOut(duration: 1.2), value: isStatic)
                .onTapGesture {
                    isStatic.toggle()
                }
            } // VSTACK
                else {
                    ContentView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isStatic = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        isActive = true
                    }
                }
        }

    }
}

struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView()
    }
}
