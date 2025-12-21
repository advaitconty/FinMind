//
//  Buttons.swift
//  Trial Manager
//
//  Created by Milind Contractor on 21/12/25.
//

import SwiftUI

extension WelcomeView {
    // MARK: Income Selection Stream Buttons.
    func incomeSelectionStreamButton(_ thing: MoneyEarnRecurringSchedule, text: String) -> some View {
        VStack {
            if selectedRecurringSchedule == thing {
                Button {
                    withAnimation {
                        selectedRecurringSchedule = .none
                    }
                } label: {
                    Spacer()
                    Text(text)
                        .font(.custom("Frutiger", size: 15, relativeTo: .body))
                    Spacer()
                }
                .adaptiveProminentButtonStyle()
                .transition(.blurReplace)
            } else {
                Button {
                    withAnimation {
                        selectedRecurringSchedule = thing
                    }
                } label: {
                    Spacer()
                    Text(text)
                        .font(.custom("Frutiger", size: 15, relativeTo: .body))
                    Spacer()
                }
                .adaptiveButtonStyle()
                .transition(.blurReplace)
            }
        }
    }
    
    // MARK: Income Selection Stream Buttons.
    func dayOfIncomeArrivalButton(_ thing: DayOfIncomeArrival, text: String) -> some View {
        VStack {
            if dayOfArrivalOfIncome == thing {
                Button {
                    withAnimation {
                        selectedRecurringSchedule = .none
                    }
                } label: {
                    Spacer()
                    Text(text)
                        .font(.custom("Frutiger", size: 15, relativeTo: .body))
                    Spacer()
                }
                .adaptiveProminentButtonStyle()
                .transition(.blurReplace)
            } else {
                Button {
                    withAnimation {
                        dayOfArrivalOfIncome = thing
                    }
                } label: {
                    Spacer()
                    Text(text)
                        .font(.custom("Frutiger", size: 15, relativeTo: .body))
                    Spacer()
                }
                .adaptiveButtonStyle()
                .transition(.blurReplace)
            }
        }
    }
    
    // MARK: Income Selection Stream Buttons.
    func incomeArrivalTimeSelector(_ thing: IncomeArrivalTimeForMonthlyIncome, text: String) -> some View {
        VStack {
            if roughTimeWhenIncomeArrives == thing {
                Button {
                    
                } label: {
                    Spacer()
                    Text(text)
                        .font(.custom("Frutiger", size: 15, relativeTo: .body))
                    Spacer()
                }
                .adaptiveProminentButtonStyle()
                .transition(.blurReplace)
            } else {
                Button {
                    withAnimation {
                        roughTimeWhenIncomeArrives = thing
                    }
                } label: {
                    Spacer()
                    Text(text)
                        .font(.custom("Frutiger", size: 15, relativeTo: .body))
                    Spacer()
                }
                .adaptiveButtonStyle()
                .transition(.blurReplace)
            }
        }
    }
}
