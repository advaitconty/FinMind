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
            
            if authorizationGrantStatusForNotifications == false {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.multicolor)
                    Text("Notifications have not been enabled. You will not get these notifications until you enable them in the Settings app.")
                }
            }   
            
            Button {
                let center = UNUserNotificationCenter.current()

                let content = UNMutableNotificationContent()
                content.title = "Daily reminder!"
                content.body = "Time to update your transactions and subscriptions for the day!"
                content.sound = UNNotificationSound.default
                
                let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: preferedTimeOfNotification)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request)
            } label: {
                Spacer()
                Image(systemName: "tick")
                Text("Set notification timing")
            }
        }
        .onAppear {
            Task {
                try? await requestNotificationAuthorization()
            }
        }
    }
}
