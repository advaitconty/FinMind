//
//  WelcomeView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/12/25.
//

import SwiftUI

struct WelcomeView: View {
    @State var showBottomPart: Bool = false
    @State var selectedRecurringSchedule: MoneyEarnRecurringSchedule = .none
    @State var dayOfArrivalOfIncome: DayOfIncomeArrival = .mon
    @State var amountOfRecuringIncome: Double = 1000.0
    @State var roughTimeWhenIncomeArrives: IncomeArrivalTimeForMonthlyIncome = .monthLateEnd
    @FocusState var incomeFieldSelectedFocusState: Bool
    @State var incomeFieldSelected: Bool = false
    @State var screenNumber: Int = 1
    @Namespace var glassNamespace
    @State var userName: String = ""
    @State var preferedNotificationTimeDaily: Date = Date()
    @Environment(\.dismiss) var dismiss
    
    let locale = Locale.current
    
    var body: some View {
        VStack {
            // MARK: INTRO CONTENT. DO NOT TOUCH THIS STUFF.
            HStack {
                Text("Welcome to \(appName)!")
                    .font(.custom("Frutiger", size: 34, relativeTo: .largeTitle))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            showBottomPart = true
                        }
                    }
                }
            }
            
            // MARK: Screen 1. To move into new file for refactor
            if showBottomPart {
                VStack {
                    if screenNumber == 1 {
                        screenOne()
                    } else if screenNumber == 2 {
                        screenTwo()
                    }
                }
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.Resolved(red: 233/255, green: 233/255, blue: 233/255))
//                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor, lineWidth: 2)
                )
                
            }
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
