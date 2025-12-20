//
//  WelcomeView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/12/25.
//

import SwiftUI

enum MoneyEarnRecurringSchedule {
    case day, month, week, yearly, none
}

struct WelcomeView: View {
    @State var showBottomPart: Bool = false
    @State var selectedRecurringSchedule: MoneyEarnRecurringSchedule = .none
    @State var amountOfRecuringIncome: Double = 1000.0
    let locale = Locale.current
    
    // MARK: Income Selection Stream Buttons. To move to new file with Mark Number 3
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
                        HStack {
                            TextField("", value: $amountOfRecuringIncome, format: .currency(code: locale.currency!.identifier))
                                .font(.custom("Frutiger", size: 15, relativeTo: .body))
                        }
                        .padding()
                        .glassEffect()
                    }
                    .padding()
                    
                }
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
