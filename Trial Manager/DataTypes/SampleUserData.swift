import Foundation

// MARK: - Sample UserData Generator

extension UserData {
    
    // MARK: Sample 1: Monthly Salary Employee
    static func monthlySalaryEmployee() -> UserData {
        let transactions = [
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                transactionName: "Grocery Shopping",
                transactionIcon: "cart",
                transactionAmount: 45.50,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                transactionName: "Restaurant Dinner",
                transactionIcon: "fork.knife",
                transactionAmount: 120.00,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Date(),
                transactionName: "Gas Station",
                transactionIcon: "fuelpump",
                transactionAmount: 35.75,
                receiptImagePath: nil
            )
        ]
        
        let subscriptions = [
            Subscription(
                subscriptionName: "Netflix",
                subscriptionType: .monthly,
                price: 15.99,
                nextCycle: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                freeTrial: false
            ),
            Subscription(
                subscriptionName: "Spotify",
                subscriptionType: .monthly,
                price: 9.99,
                nextCycle: Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
                freeTrial: false
            )
        ]
        
        return UserData(
            name: "Sarah Johnson",
            dailyNotificationRingTime: Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!,
            notificationsPermissionGiven: true,
            recurringIncomeType: .month,
            recurringIncomeAmount: 5000.00,
            incomeArrivalTimeForMonthlyIncome: .monthLateEnd,
            transactions: transactions,
            subscriptions: subscriptions
        )
    }
    
    // MARK: Sample 2: Weekly Income Worker
    static func weeklyIncomeWorker() -> UserData {
        let transactions = [
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                transactionName: "Electric Bill",
                transactionIcon: "bolt",
                transactionAmount: 85.30,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                transactionName: "Coffee Shop",
                transactionIcon: "cup.and.saucer",
                transactionAmount: 50.00,
                receiptImagePath: nil
            )
        ]
        
        let subscriptions = [
            Subscription(
                subscriptionName: "Gym Membership",
                subscriptionType: .monthly,
                price: 45.00,
                nextCycle: Calendar.current.date(byAdding: .day, value: 20, to: Date())!,
                freeTrial: false
            ),
            Subscription(
                subscriptionName: "iCloud Storage",
                subscriptionType: .monthly,
                price: 2.99,
                nextCycle: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
                freeTrial: false
            )
        ]
        
        return UserData(
            name: "Marcus Chen",
            dailyNotificationRingTime: Calendar.current.date(from: DateComponents(hour: 8, minute: 30))!,
            notificationsPermissionGiven: true,
            recurringIncomeType: .week,
            recurringIncomeAmount: 800.00,
            incomeArrivalTimeForMonthlyIncome: .monthStart,
            transactions: transactions,
            subscriptions: subscriptions
        )
    }
    
    // MARK: Sample 3: Freelancer with Inconsistent Income
    static func freelancer() -> UserData {
        let transactions = [
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                transactionName: "Office Supplies",
                transactionIcon: "pencil.and.outline",
                transactionAmount: 250.00,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
                transactionName: "Internet Bill",
                transactionIcon: "wifi",
                transactionAmount: 75.50,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                transactionName: "Client Lunch",
                transactionIcon: "fork.knife",
                transactionAmount: 120.00,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                transactionName: "Book Store",
                transactionIcon: "book",
                transactionAmount: 45.99,
                receiptImagePath: nil
            )
        ]
        
        let subscriptions = [
            Subscription(
                subscriptionName: "Adobe Creative Cloud",
                subscriptionType: .monthly,
                price: 54.99,
                nextCycle: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                freeTrial: false
            ),
            Subscription(
                subscriptionName: "ChatGPT Plus",
                subscriptionType: .monthly,
                price: 20.00,
                nextCycle: Calendar.current.date(byAdding: .day, value: 12, to: Date())!,
                freeTrial: true
            ),
            Subscription(
                subscriptionName: "Dropbox",
                subscriptionType: .annually,
                price: 119.88,
                nextCycle: Calendar.current.date(byAdding: .month, value: 8, to: Date())!,
                freeTrial: false
            )
        ]
        
        return UserData(
            name: "Alex Rivera",
            dailyNotificationRingTime: Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!,
            notificationsPermissionGiven: true,
            recurringIncomeType: .inconsistent,
            recurringIncomeAmount: nil,
            incomeArrivalTimeForMonthlyIncome: .monthStart,
            transactions: transactions,
            subscriptions: subscriptions
        )
    }
    
    // MARK: Sample 4: Student (No Regular Income)
    static func student() -> UserData {
        let transactions = [
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                transactionName: "Fast Food",
                transactionIcon: "takeoutbag.and.cup.and.straw",
                transactionAmount: 12.50,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Date(),
                transactionName: "Campus Cafe",
                transactionIcon: "cup.and.saucer",
                transactionAmount: 8.75,
                receiptImagePath: nil
            )
        ]
        
        let subscriptions = [
            Subscription(
                subscriptionName: "Spotify Student",
                subscriptionType: .monthly,
                price: 5.99,
                nextCycle: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                freeTrial: false
            ),
            Subscription(
                subscriptionName: "Apple Music",
                subscriptionType: .monthly,
                price: 5.99,
                nextCycle: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                freeTrial: true
            )
        ]
        
        return UserData(
            name: "Emma Wilson",
            dailyNotificationRingTime: Calendar.current.date(from: DateComponents(hour: 7, minute: 0))!,
            notificationsPermissionGiven: false,
            recurringIncomeType: .none,
            recurringIncomeAmount: nil,
            incomeArrivalTimeForMonthlyIncome: .monthStart,
            transactions: transactions,
            subscriptions: subscriptions
        )
    }
    
    // MARK: Sample 5: Daily Income Worker
    static func dailyIncomeWorker() -> UserData {
        let transactions = [
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                transactionName: "Lunch",
                transactionIcon: "fork.knife",
                transactionAmount: 30.00,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                transactionName: "Transportation",
                transactionIcon: "bus",
                transactionAmount: 25.50,
                receiptImagePath: nil
            ),
            Transaction(
                timeOfTransaction: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                transactionName: "Snacks",
                transactionIcon: "cart",
                transactionAmount: 15.00,
                receiptImagePath: nil
            )
        ]
        
        let subscriptions = [
            Subscription(
                subscriptionName: "Mobile Data Plan",
                subscriptionType: .monthly,
                price: 35.00,
                nextCycle: Calendar.current.date(byAdding: .day, value: 18, to: Date())!,
                freeTrial: false
            )
        ]
        
        return UserData(
            name: "Raj Patel",
            dailyNotificationRingTime: Calendar.current.date(from: DateComponents(hour: 6, minute: 30))!,
            notificationsPermissionGiven: true,
            recurringIncomeType: .day,
            recurringIncomeAmount: 150.00,
            incomeArrivalTimeForMonthlyIncome: .monthStart,
            transactions: transactions,
            subscriptions: subscriptions
        )
    }
    
    // MARK: Helper to get all samples
    static func allSamples() -> [UserData] {
        return [
            monthlySalaryEmployee(),
            weeklyIncomeWorker(),
            freelancer(),
            student(),
            dailyIncomeWorker()
        ]
    }
}

// MARK: - Usage Example
/*
 // In your SwiftData ModelContainer setup:
 let sampleUser = UserData.monthlySalaryEmployee()
 modelContext.insert(sampleUser)
 
 // Or insert all samples for testing:
 for sample in UserData.allSamples() {
     modelContext.insert(sample)
 }
 */
