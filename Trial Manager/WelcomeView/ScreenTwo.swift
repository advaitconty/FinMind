//
//  ScreenTwo.swift
//  Trial Manager
//
//  Created by Milind Contractor on 22/12/25.
//

import SwiftUI

extension WelcomeView {
    func screenTwo() -> some View {
        VStack {
            Text("Next, what time should we remind you to update your finances everyday?")
                .frame(maxWidth: .infinity, alignment: .leading)
            DatePicker("", selection: $preferedTimeOfNotification, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
        }
    }
}
