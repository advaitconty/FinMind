//
//  DataItems.swift
//  Trial Manager
//
//  Created by Milind Contractor on 21/12/25.
//

import SwiftData
import Foundation
import UIKit

enum MoneyEarnRecurringSchedule: Codable {
    case day, month, week, yearly, inconsistent, none
}

enum DayOfIncomeArrival: Codable {
    case mon, tue, wed, thu, fri, sat, sun
}

enum IncomeArrivalTimeForMonthlyIncome: Codable {
    case monthEarlyEnd, monthLateEnd, monthStart
}

enum TransactionType: Codable {
    case essential, rent, facilities, food, utilities, shopping, other
}

// MARK: user data management
struct Transaction: Codable, Identifiable {
    var id: UUID = UUID()
    var timeOfTransaction: Date = Date()
    var transactionName: String
    var transactionIcon: String = "creditcard"
    var transactionAmount: Double
    var receiptImagePath: String?
}

enum SubscriptionType: Codable {
    case monthly, annually
}

struct Subscription: Codable, Identifiable {
    var id: UUID = UUID()
    var subscriptionName: String
    var subscriptionType: SubscriptionType = .monthly
    var price: Double
    var nextCycle: Date
    var freeTrial: Bool = false
}

@Model
class UserData {
    var name: String
    var dailyNotificationRingTime: Date
    var notificationsPermissionGiven: Bool = false
    var balance: Double = 0.0
    
    // Reccuring income settings
    var recurringIncomeType: MoneyEarnRecurringSchedule?
    var recurringIncomeAmount: Double?
    var incomeArrivalTimeForMonthlyIncome: IncomeArrivalTimeForMonthlyIncome
    
    // Financial tracking
    @Relationship(deleteRule: .cascade)
    var transactions: [Transaction]
    
    // Subscriptions
    var subscriptions: [Subscription]
    
    init(name: String, dailyNotificationRingTime: Date, notificationsPermissionGiven: Bool, recurringIncomeType: MoneyEarnRecurringSchedule? = nil, recurringIncomeAmount: Double? = nil, incomeArrivalTimeForMonthlyIncome: IncomeArrivalTimeForMonthlyIncome, transactions: [Transaction], subscriptions: [Subscription]) {
        self.name = name
        self.dailyNotificationRingTime = dailyNotificationRingTime
        self.notificationsPermissionGiven = notificationsPermissionGiven
        self.recurringIncomeType = recurringIncomeType
        self.recurringIncomeAmount = recurringIncomeAmount
        self.incomeArrivalTimeForMonthlyIncome = incomeArrivalTimeForMonthlyIncome
        self.transactions = transactions
        self.subscriptions = subscriptions
    }
}



/// NOTES ON FINMINDER
/// 1. Receipt storage: to implement. This needs to be added later
/// 2. This app may be submitted for SSC 2027
