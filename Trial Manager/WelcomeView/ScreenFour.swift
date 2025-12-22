//
//  ScreenFour.swift
//  Trial Manager
//
//  Created by Milind Contractor on 22/12/25.
//

import SwiftUI

extension WelcomeView {
    func dayButton(_ dayOfIncomeArrival: DayOfIncomeArrival, day: String) -> some View {
        VStack {
            if dayMoneyIsRecieved == dayOfIncomeArrival {
                Button {
                    withAnimation {
                        dayMoneyIsRecieved = dayOfIncomeArrival
                    }
                } label: {
                    
                    Text(day)
                }
                .adaptiveProminentButtonStyle()
            } else {
                Button {
                    withAnimation {
                        dayMoneyIsRecieved = dayOfIncomeArrival
                    }
                } label: {
                    Text(day)
                }
                .adaptiveButtonStyle()
            }
        }
    }
    
    func payCheckbuttons(text: String, item: IncomeArrivalTimeForMonthlyIncome, caption: String) -> some View {
        VStack {
            if item == incomeArrivalTimeForMonthlyIncome {
                Button {
                    withAnimation {
                        incomeArrivalTimeForMonthlyIncome = item
                    }
                } label: {
                    VStack {
                        Text(text)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(caption)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
                .adaptiveProminentButtonStyle()
            } else {
                Button {
                    withAnimation {
                        incomeArrivalTimeForMonthlyIncome = item
                    }
                } label: {
                    VStack {
                        Text(text)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(caption)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
                .adaptiveButtonStyle()
            }
        }
    }
    
    func screenFour() -> some View {
        VStack {
            if earningRecurringSchedule == MoneyEarnRecurringSchedule.none || earningRecurringSchedule == MoneyEarnRecurringSchedule.inconsistent {
                Text("Finally, since you earn nothing, how much money do you currently have? This will automatically be added to your balance.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", value: $moneyMadeInThatTime, format: .currency(code: locale.currency!.identifier))
                    .textFieldStyle(.roundedBorder)
            } else  {
                Text("Finally, how much money do you make in that time, and most importantly, around when do you get it?")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", value: $moneyMadeInThatTime, format: .currency(code: locale.currency!.identifier))
                    .textFieldStyle(.roundedBorder)
                
                // If it is daily
                if earningRecurringSchedule == .week {
                    HStack {
                        Text("Day which money is earnt")
                        Spacer()
                        Picker("Day money is received", selection: $dayMoneyIsRecieved) {
                            Text("Monday")
                                .tag(DayOfIncomeArrival.mon)
                            Text("Tuesday")
                                .tag(DayOfIncomeArrival.tue)
                            Text("Wednesday")
                                .tag(DayOfIncomeArrival.wed)
                            Text("Thursday")
                                .tag(DayOfIncomeArrival.thu)
                            Text("Friday")
                                .tag(DayOfIncomeArrival.fri)
                            Text("Saturday")
                                .tag(DayOfIncomeArrival.sat)
                            Text("Sunday")
                                .tag(DayOfIncomeArrival.sun)
                        }
                        .onChange(of: dayMoneyIsRecieved) {
                            if dayMoneyIsRecieved != nil {
                                withAnimation {
                                    showNextButton = true
                                }
                            }
                        }
                    }
                    .onAppear {
                        withAnimation {
                            showNextButton = false
                        }
                    }
                } else if earningRecurringSchedule == .month {
                    payCheckbuttons(text: "Early Month End", item: .monthEarlyEnd, caption: "Around the 20th to the 25th")
                    payCheckbuttons(text: "Late Month End", item: .monthLateEnd, caption: "Around the 26th to the 31st")
                    payCheckbuttons(text: "Next Month Start", item: .monthStart, caption: "Around the 1st to the 5th")
                        .onAppear {
                            withAnimation {
                                showNextButton = false
                            }
                        }
                        .onChange(of: incomeArrivalTimeForMonthlyIncome) {
                            if incomeArrivalTimeForMonthlyIncome != nil {
                                withAnimation {
                                    showNextButton = true
                                }
                            }
                        }
                }
            }
        }
    }
}
