
//
//  ContentView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/12/25.
//

import SwiftUI
import SwiftData

enum SelectedTab: Codable {
    case home, transactions, receipts, settings, transact, subscriptions
}

struct ContentView: View {
    @State var selectedTab: SelectedTab = .home
    @AppStorage("showSetupScreen") var showSetupScreen: Bool = true
    @Environment(\.modelContext) var modelContext
    @Query var swiftDataUserData: [UserData]
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
                
            }
            
            
            Tab("Settings", systemImage: "gearshape.2", value: .settings) {
                Text("Settings")
            }
        }
        .fullScreenCover(isPresented: $showSetupScreen) {
            WelcomeView(userData: userData)
        }
    }
}

#Preview {
    ContentView()
}
