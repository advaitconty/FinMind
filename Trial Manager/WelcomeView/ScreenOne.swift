//
//  ScreenOne.swift
//  Trial Manager
//
//  Created by Milind Contractor on 21/12/25.
//

import SwiftUI

extension WelcomeView {
    func screenOne() -> some View {
        VStack {
            Text("How much money do you earn in a day/week/month?")
                .font(.custom("Frutiger", size: 18, relativeTo: .body))
            
            VStack {
                Text("INCOME TYPE:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Frutiger", size: 14, relativeTo: .body))
                HStack {
                    incomeSelectionStreamButton(.day, text: "Daily")
                    incomeSelectionStreamButton(.week, text: "Weekly")
                    incomeSelectionStreamButton(.month, text: "Monthly")
                }
            }
            .padding()
            
            VStack {
                Text("INCOME AMOUNT (AFTER TAXES):")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Frutiger", size: 14, relativeTo: .body))
                VStack {
                    HStack {
                        TextField("", value: $amountOfRecuringIncome, format: .currency(code: locale.currency!.identifier))
                            .font(.custom("Frutiger", size: 15, relativeTo: .body))
                            .focused($incomeFieldSelectedFocusState)
                            .onChange(of: incomeFieldSelectedFocusState) {
                                withAnimation {
                                    incomeFieldSelected = incomeFieldSelectedFocusState
                                }
                            }
                    }
                    .padding()
                    .glassEffect()
                    .glassEffectID("incomeGlass", in: glassNamespace)
                    
                    if incomeFieldSelected {
                        Text("The amount will be added to your balance now and again at the selected income type's time. If no income type is set, you must manually update your balance when you receive income.")
                            .font(.custom("Frutiger", size: 16, relativeTo: .body))
                            .glassEffect()
                            .glassEffectID("incomeGlass", in: glassNamespace)
                            .transition(.asymmetric(insertion: .identity, removal: .opacity))
                            .padding()
                    }
                    
                }
            }
            .padding()
            
            if selectedRecurringSchedule == .week {
                VStack {
                    Text("DAY WHEN CASH ARRIVES")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Frutiger", size: 14, relativeTo: .body))
                    VStack {
                        HStack {
                            dayOfIncomeArrivalButton(.mon, text: "Mon")
                            dayOfIncomeArrivalButton(.tue, text: "Tue")
                            dayOfIncomeArrivalButton(.wed, text: "Wed")
                        }
                        HStack {
                            dayOfIncomeArrivalButton(.thu, text: "Thu")
                            dayOfIncomeArrivalButton(.fri, text: "Fri")
                            dayOfIncomeArrivalButton(.sat, text: "Sat")
                            dayOfIncomeArrivalButton(.sun, text: "Sun")
                        }
                    }
                }
                .transition(.blurReplace)
            }
            
            if selectedRecurringSchedule == .month {
                VStack {
                    Text("ESTIMATED INCOME DATE:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Frutiger", size: 14, relativeTo: .body))
                    HStack {
                        incomeArrivalTimeSelector(.monthEarlyEnd, text: "Month End (Early)")
                        incomeArrivalTimeSelector(.monthLateEnd, text: "Month End (Late)")
                        incomeArrivalTimeSelector(.monthStart, text: "Month Start")
                    }
                }
                .padding()
            }
            
            
            Button {
                withAnimation(.default, completionCriteria: .removed) {
                    screenNumber += 1
                } completion: {
                    print("Next screen")
                }
            } label: {
                Image(systemName: "arrow.right")
                Text("Next")
                    .font(.custom("Frutiger", size: 18, relativeTo: .body))
            }
            .adaptiveProminentButtonStyle()
        }
        .padding()
        .transition(.slide)
    }
}
