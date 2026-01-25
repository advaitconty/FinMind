//
//  DataItems.swift
//  Trial Manager
//
//  Created by Milind Contractor on 21/12/25.
//

import SwiftData
import SwiftUI
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

enum TransactionType: String, Codable, CaseIterable {
    case essential = "Essential"
    case rent = "Rent"
    case facilities = "Facility Rental"
    case food = "Food"
    case utilities = "Utilities"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case gifts = "Gifts"
    case insurance = "Insurance"
    case medical = "Medical"
    case education = "Education"
    case clothing = "Clothing"
    case travel = "Travel"
    case miscellaneous = "Miscellaneous"
    case paycheck = "Paycheck"
    case sideIncome = "Side Income"
    case taxes = "Taxes"
    case other = "Other"
}

extension TransactionType {
    static func pickerOptions(isIncomeMode: Bool) -> [TransactionType] {
        if isIncomeMode {
            return [.paycheck, .sideIncome]
        } else {
            return Self.allCases.filter {
                $0 != .paycheck && $0 != .sideIncome
            }
        }
    }
}


// MARK: user data management
struct Transaction: Codable, Identifiable {
    var id: UUID = UUID()
    var timeOfTransaction: Date = Date()
    var transactionName: String
    var transactionIcon: String = "creditcard"
    var transactionAmount: Double
    var receiptImagePath: String?
    var iconBackgroundColor: Color = .blue
    var transactionCategory: TransactionType = .essential
    var additionToBankAccount: Bool = false
}

enum SubscriptionType: String, Codable {
    case monthly = "month"
    case annually = "year"
}

enum SubscriptionPriority: String, Codable, CaseIterable {
    case important = "Important"
    case entertainment = "Entertainment"
    case convenience = "Convinence-related service"
    case required = "Required for work/living"
    case other = "Other recurring expense"
}

struct Subscription: Codable, Identifiable {
    var id: UUID = UUID()
    var subscriptionName: String
    var subscriptionIcon: String
    var subscriptionType: SubscriptionType = .monthly
    var price: Double
    var nextCycle: Date
    var freeTrial: Bool = false
    var freeTrialEndDate: Date?
    var subscriptionColor: Color = .cyan
    var wantsReminderwhenFreeTrialExpires: Bool = false
    var subscriptionPriority: SubscriptionPriority = .convenience
}

@Model
class UserData {
    var name: String
    var dailyNotificationRingTime: Date
    var notificationsPermissionGiven: Bool = false
    var balance: Double = 0.0
    var lastAddedIncomeTime: Date = Date()
    
    var nextIncomeTime: Date = Date()
    
    // Reccuring income settings
    var recurringIncomeType: MoneyEarnRecurringSchedule?
    var recurringIncomeAmount: Double?
    var incomeArrivalTimeForMonthlyIncome: IncomeArrivalTimeForMonthlyIncome?
    
    // Financial tracking
    var transactions: [Transaction]
    
    // Subscriptions
    var subscriptions: [Subscription]
    
    init(name: String, dailyNotificationRingTime: Date, notificationsPermissionGiven: Bool, balance: Double = 0.0, recurringIncomeType: MoneyEarnRecurringSchedule? = nil, recurringIncomeAmount: Double? = nil, incomeArrivalTimeForMonthlyIncome: IncomeArrivalTimeForMonthlyIncome?, transactions: [Transaction], subscriptions: [Subscription]) {
        self.name = name
        self.dailyNotificationRingTime = dailyNotificationRingTime
        self.notificationsPermissionGiven = notificationsPermissionGiven
        self.balance = balance
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
