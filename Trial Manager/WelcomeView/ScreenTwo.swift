//
//  ScreenTwo.swift
//  Trial Manager
//
//  Created by Milind Contractor on 22/12/25.
//

import SwiftUI
import UserNotifications

extension WelcomeView {
    func requestNotificationAuthorization() async throws {
        let center = UNUserNotificationCenter.current()
        // Define the types of authorization you need
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        do {
            let granted = try await center.requestAuthorization(options: options)
            authorizationGrantStatusForNotifications = granted
        } catch {
            throw error
        }
    }

    func screenTwo() -> some View {
        VStack {
            Text("Next, what time should we remind you to update your finances everyday?")
                .frame(maxWidth: .infinity, alignment: .leading)
            DatePicker("", selection: $preferedTimeOfNotification, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
        }
        .onAppear {
            Task {
                try? await requestNotificationAuthorization()
            }
        }
    }
}
