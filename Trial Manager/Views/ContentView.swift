
//
//  ContentView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/12/25.
//

import SwiftUI
import SwiftData
import Combine

enum SelectedTab: Codable {
    case home, transactions, receipts, settings, transact, subscriptions
}

struct ContentView: View {
    @State var selectedTab: SelectedTab = .home
    @AppStorage("showSetupScreen") var showSetupScreen: Bool = true // CHANGE TO TRUE WHEN RELEASING
    @Environment(\.modelContext) var modelContext
    @Query var swiftDataUserData: [UserData]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: Random date generator
    func randomDate(year: Int, month: Int, dayRange: ClosedRange<Int>, calendar: Calendar = .current) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = .random(in: dayRange)
        components.hour = 9
        return calendar.date(from: components)
    }
    
    // MARK: next date generator
    func nextMonthlyIncomeDate(
        after date: Date,
        window: IncomeArrivalTimeForMonthlyIncome,
        calendar: Calendar = .current
    ) -> Date {
        let base = calendar.dateComponents([.year, .month], from: date)
        
        switch window {
        case .monthEarlyEnd:
            return randomDate(
                year: base.year!,
                month: base.month!,
                dayRange: 20...25,
                calendar: calendar
            )!
            
        case .monthLateEnd:
            return randomDate(
                year: base.year!,
                month: base.month!,
                dayRange: 26...31,
                calendar: calendar
            )!
            
        case .monthStart:
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)!
            let comps = calendar.dateComponents([.year, .month], from: nextMonth)
            return randomDate(
                year: comps.year!,
                month: comps.month!,
                dayRange: 1...5,
                calendar: calendar
            )!
        }
    }
    
    
    var userData: Binding<UserData> {
        Binding {
            if !swiftDataUserData.isEmpty {
                return swiftDataUserData.first!
            } else {
                return UserData.monthlySalaryEmployee()
            }
        } set: { value in
            if let item = swiftDataUserData.first {
                item.name = value.name
                item.dailyNotificationRingTime = value.dailyNotificationRingTime
                item.notificationsPermissionGiven = value.notificationsPermissionGiven
                item.balance = item.balance
                item.recurringIncomeType = value.recurringIncomeType
                item.recurringIncomeAmount = value.recurringIncomeAmount
                item.incomeArrivalTimeForMonthlyIncome = value.incomeArrivalTimeForMonthlyIncome
                item.transactions = value.transactions
                item.subscriptions = value.subscriptions
            } else {
                modelContext.insert(value)
            }
            try? modelContext.save()
        }
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            // To be added along with recieipts
            //            Tab("Receipts", systemImage: "receipt", value: .home) {
            //                Text("Home")
            //            }
            
            
            Tab("Home", systemImage: "house", value: .home) {
                HomeView(userData: userData)
            }
            
            // To be added along with recieipts
            //            Tab("New Log", systemImage: "minus.forwardslash.plus", value: .transact) {
            //                Text("View transactions")
            //            }
            
            Tab("Ledger", systemImage: "book.pages", value: .transactions) {
                TransactionsView(userData: userData)
            }
            
            Tab("Subscriptions", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90", value: .subscriptions) {
                SubscriptionsView(userData: userData)
                
            }
            
            
            if getInfoToShowView() {
                Tab("Summary", systemImage: "list.bullet.rectangle", value: .settings) {
                    AIView(userData: userData)
                }
            }
        }
        .fullScreenCover(isPresented: $showSetupScreen) {
            WelcomeView(userData: userData)
        }
        .onReceive(timer) { _ in
            for (subscriptionIndex, subscription) in userData.wrappedValue.subscriptions.enumerated() {
                if Calendar.current.isDateInToday(subscription.nextCycle) || subscription.nextCycle < Date() {
                    userData.wrappedValue.transactions.append(Transaction(transactionName: "Subscription: \(subscription.subscriptionName)", transactionAmount: subscription.price))
                    
                    if subscription.subscriptionType == .annually {
                        userData.wrappedValue.subscriptions[subscriptionIndex].nextCycle = Calendar.current.date(byAdding: .year, value: 1, to: subscription.nextCycle) ?? Date()
                    } else if subscription.subscriptionType == .monthly {
                        userData.wrappedValue.subscriptions[subscriptionIndex].nextCycle = Calendar.current.date(byAdding: .month, value: 1, to: subscription.nextCycle) ?? Date()
                    }
                }
            }
            
            guard let amount = userData.wrappedValue.recurringIncomeAmount, userData.wrappedValue.recurringIncomeType != .inconsistent else { return }
            
            let calendar = Calendar.current
            let now = Date()
            
            while userData.wrappedValue.nextIncomeTime <= now {
                userData.wrappedValue.balance += userData.wrappedValue.recurringIncomeAmount!
                userData.wrappedValue.lastAddedIncomeTime = userData.wrappedValue.nextIncomeTime
                
                if userData.wrappedValue.recurringIncomeType == .day {
                    calendar.date(byAdding: .day, value: 1, to: userData.wrappedValue.nextIncomeTime)!
                } else if userData.wrappedValue.recurringIncomeType == .week {
                    userData.wrappedValue.nextIncomeTime = calendar.date(byAdding: .weekOfYear, value: 1, to: userData.wrappedValue.nextIncomeTime)!
                } else if userData.wrappedValue.recurringIncomeType == .month {
                    userData.wrappedValue.nextIncomeTime = nextMonthlyIncomeDate(after: userData.wrappedValue.nextIncomeTime, window: userData.wrappedValue.incomeArrivalTimeForMonthlyIncome!)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
