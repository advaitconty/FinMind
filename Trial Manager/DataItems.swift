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
    case day, month, week, yearly, none
}

enum DayOfIncomeArrival: Codable {
    case mon, tue, wed, thu, fri, sat, sun
}

enum IncomeArrivalTimeForMonthlyIncome: Codable {
    case monthEarlyEnd, monthLateEnd, monthStart
}


// MARK: Receipt Storage
enum ReceiptImageStore {
    private static let folderName = "Receipts"
    private static var baseURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        
        let folder = base.appendingPathComponent(folderName)
        
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        
        return folder
    }
    
    static func saveImage(_ image: UIImage) -> String? {
        let filename = UUID().uuidString + ".jpg"
        let url = baseURL.appendingPathComponent(filename)
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        
        do {
            try data.write(to: url, options: .atomic)
            return filename
        } catch {
            print("Save failure:", error)
            return nil
        }
    }
    
    static func loadImage(from path: String) -> UIImage? {
        let url = baseURL.appendingPathComponent(path)
        return UIImage(contentsOfFile: url.path())
    }
    
    static func deleteImage(at path: String) -> Bool {
        let url = baseURL.appendingPathComponent(path)
        do {
            try? FileManager.default.removeItem(at: url)
            return true
        } catch {
            print("Delete failure:", error)
            return false
        }
    }
}

// MARK: add/delete transaction
func addTransaction(amount: Double, image: UIImage?, to userData: UserData, modelContext: ModelContext) {
    
    var transaction = Transaction(transactionAmount: amount)

    if let image,
       let imagePath = ReceiptImageStore.saveImage(image) {
        transaction.receiptImagePath = imagePath
    }

    userData.transactions.append(transaction)
    try? modelContext.save()
}

func deleteTransaction(_ transaction: Transaction, from userData: UserData, modelContext: ModelContext) {
    if let path = transaction.receiptImagePath {
        ReceiptImageStore.deleteImage(at: path)
    }

    userData.transactions.removeAll { $0.id == transaction.id }
    try? modelContext.save()
}

// MARK: user data management
struct Transaction: Codable, Identifiable {
    var id: UUID = UUID()
    var timeOfTransaction: Date = Date()
    var transactionAmount: Double
    var receiptImagePath: String?
}

struct Subscription: Codable, Identifiable {
    var id: UUID = UUID()
    var pricePerMonth: Double
    var nextCycle: Date
    var freeTrial: Bool = false
}

@Model
class UserData {
    var name: String
    var dailyNotificationRingTime: Date
    var notificationsPermissionGiven: Bool = false
    
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
