//
//  ScreenThree.swift
//  Trial Manager
//
//  Created by Milind Contractor on 22/12/25.
//

import SwiftUI

extension WelcomeView {
    func incomeSourceButton(_ incomeType: MoneyEarnRecurringSchedule, title: String, body: String) -> some View {
        Button {
            withAnimation {
                earningRecurringSchedule = incomeType
            }
        } label: {
            VStack {
                Text(title)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(body)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(colorScheme == .dark ? .white : (earningRecurringSchedule == incomeType ? Color.white : Color.black))
            .padding()
            .background(earningRecurringSchedule == incomeType ? Color.accentColor : Color.accentColor.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
        }
        .buttonStyle(.plain)
    }
    
    func screenThree() -> some View {
        VStack {
            Text("Almost there, just need to know how often you get paid.")
            incomeSourceButton(.day, title: "Daily", body: "Paid everyday")
            incomeSourceButton(.week, title: "Weekly", body: "Paid every week")
            incomeSourceButton(.month, title: "Monthly", body: "Paid every month")
            incomeSourceButton(.inconsistent, title: "Inconsistent", body: "No consistent income stream")
            incomeSourceButton(.none, title: "None", body: "No income")
                .onChange(of: earningRecurringSchedule) {
                    withAnimation {
                        showNextButton = true
                    }
                }
                .onAppear() {
                    if earningRecurringSchedule == nil {
                        withAnimation {
                            showNextButton = false
                        }
                    } else {
                        withAnimation {
                            showNextButton = true
                        }
                    }
                }
        }
    }
}
