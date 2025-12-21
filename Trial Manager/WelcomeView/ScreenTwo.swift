//
//  ScreenTwo.swift
//  Trial Manager
//
//  Created by Milind Contractor on 21/12/25.
//

import SwiftUI

extension WelcomeView {
    func screenTwo() -> some View {
        VStack {
            Text("Finally, let's get your name and your preferred time to send your daily notification to check the app.")
                .font(.custom("Frutiger", size: 18, relativeTo: .body))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text("NAME")
                    .font(.custom("Frutiger", size: 14, relativeTo: .body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing])
                HStack {
                    TextField("Jake", text: $userName)
                        .font(.custom("Frutiger", size: 15, relativeTo: .body))
                }
                .padding()
                .glassEffect()
            }
            .padding()
            
            VStack {
                Text("PREFERRED REMINDER TIME")
                    .font(.custom("Frutiger", size: 14, relativeTo: .body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing])
                HStack {
                    DatePicker("Time", selection: $preferedNotificationTimeDaily, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .font(.custom("Frutiger", size: 14, relativeTo: .body))
                }
                .glassEffect()
            }
            .padding()
            
            
            Text("You'll receive a daily \(appName) notification to update your finances at this time everyday.")
                .multilineTextAlignment(.leading)
                .font(.custom("Frutiger", size: 15, relativeTo: .body))
                .padding()
            
            HStack {
                Button {
                    withAnimation {
                        screenNumber -= 1
                    }
                } label: {
                    Image(systemName: "arrow.left")
                    Text("Back")
                        .font(.custom("Frutiger", size: 18, relativeTo: .body))
                }
                .adaptiveButtonStyle()
                
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                        Text("Finish Setup")
                            .font(.custom("Frutiger", size: 18, relativeTo: .body))
                    }
                    .adaptiveProminentButtonStyle()
            }
        }
        .padding()
    }
}
