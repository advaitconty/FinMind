//
//  ScreenOne.swift
//  Trial Manager
//
//  Created by Milind Contractor on 22/12/25.
//

import SwiftUI

extension WelcomeView {
    func screenOne() -> some View {
        VStack {
            Text("Before we start, what should we call you?")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Warren Buffet", text: $userName)
                .textFieldStyle(.roundedBorder)
                .onChange(of: userName) {
                    if !userName.isEmpty {
                        withAnimation {
                            showNextButton = true
                        }
                    } else {
                        withAnimation {
                            showNextButton = false
                        }
                    }
                }
                .onAppear {
                    if !userName.isEmpty {
                        withAnimation {
                            showNextButton = true
                        }
                    } else {
                        withAnimation {
                            showNextButton = false
                        }
                    }
                }
        }
    }
}
