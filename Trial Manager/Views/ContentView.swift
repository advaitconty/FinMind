
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
    @AppStorage("showSetupScreen") var showSetupScreen: Bool = true
    @Environment(\.modelContext) var modelContext
    @Query var swiftDataUserData: [UserData]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
            
            
            Tab("Settings", systemImage: "gearshape.2", value: .settings) {
                Text("Settings")
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
            
            if (userData.wrappedValue.nextIncomeTime < Date() || Calendar.current.isDateInToday(userData.wrappedValue.nextIncomeTime)) && (userData.wrappedValue.recurringIncomeType != .inconsistent || userData.wrappedValue.recurringIncomeType != MoneyEarnRecurringSchedule.none){
                userData.wrappedValue.balance += userData.wrappedValue.recurringIncomeAmount!
                if userData.wrappedValue.recurringIncomeType == .day {
                    userData.wrappedValue.nextIncomeTime = Calendar.current.date(byAdding: .day, value: 1, to: userData.wrappedValue.nextIncomeTime) ?? Date()
                } else if userData.wrappedValue.recurringIncomeType == .week {
                    userData.wrappedValue.nextIncomeTime = Calendar.current.date(byAdding: .day, value: 7, to: userData.wrappedValue.nextIncomeTime) ?? Date()
                }
                // MARK: Try to fix and make it work when user doesn't log in for multiple days
                // MARK: To finish: monthly logic
            }
        }
    }
}

#Preview {
    ContentView()
}
