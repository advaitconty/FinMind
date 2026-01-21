//
//  WelcomeView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 22/12/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var phaseNumber: Int = 1
    @State var preferedTimeOfNotification: Date = Date()
    @State var showNextButton: Bool = false
    @State var userName: String = ""
    @State var earningRecurringSchedule: MoneyEarnRecurringSchedule? = nil
    @State var moneyMadeInThatTime: Double = 1000.0
    @State var dayMoneyIsRecieved: DayOfIncomeArrival? = nil
    @State var incomeArrivalTimeForMonthlyIncome: IncomeArrivalTimeForMonthlyIncome? = nil
    @Binding var userData: UserData
    @State var authorizationGrantStatusForNotifications: Bool = false
        
    let locale = Locale.current

    var body: some View {
        ZStack {
            Color.accentColor.opacity(0.2)
            VStack(spacing: 0) {
                VStack {
                        Text("Welcome to \(appName)!")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white)
                        Text("Let's get you setup to use the world's best finances tracker.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white)
                    ProgressView(value: Float(phaseNumber)/4)
                        .tint(.white)
                }
                .padding()
                .background(Color.accentColor)
                VStack {
                    if phaseNumber == 1 {
                        screenOne()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if phaseNumber == 2 {
                        screenTwo()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if phaseNumber == 3 {
                        screenThree()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if phaseNumber == 4 {
                            screenFour()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                    
                    HStack {
                        if phaseNumber != 1 {
                            Button {
                                withAnimation(.easeInOut, completionCriteria: .removed) {
                                    phaseNumber -= 1
                                } completion: {
                                    print("Done")
                                }
                            } label: {
                                Spacer()
                                Image(systemName: "arrow.left")
                                Text("Back")
                                Spacer()
                            }
                            .adaptiveButtonStyle()
                        }
                        if showNextButton {
                            if phaseNumber != 4 {
                                Button {
                                    withAnimation(.easeInOut, completionCriteria: .removed) {
                                        phaseNumber += 1
                                    } completion: {
                                        print("Done")
                                    }
                                } label: {
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                    Text("Next")
                                    Spacer()
                                }
                                .adaptiveProminentButtonStyle()
                            } else {
                                Button {
                                    userData = UserData(name: userName, dailyNotificationRingTime: preferedTimeOfNotification, notificationsPermissionGiven: authorizationGrantStatusForNotifications, balance: moneyMadeInThatTime, incomeArrivalTimeForMonthlyIncome: incomeArrivalTimeForMonthlyIncome ?? nil, transactions: [], subscriptions: [])
                                    dismiss()
                                } label: {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                    Text("Finish")
                                    Spacer()
                                }
                                .adaptiveProminentButtonStyle()
                            }
                        }
                    }
                }
                .padding()
                .background(colorScheme != .dark ? Color.white : Color.black)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .padding()
        }
        .ignoresSafeArea()
    }
}

//#Preview {
//    WelcomeView(userData: <#Binding<UserData>#>)
//}
