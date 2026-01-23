//
//  AITooling.swift
//  Trial Manager
//
//  Created by Milind Contractor on 23/1/26.
//

import FoundationModels
import Foundation

final class GetUserProfileTool: Tool {
    var name: String { "getUserProfile" }
    var description: String { "Get the user's name, current balance, and next income information." }
    
    private let userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
    }
    
    @Generable
    struct Arguments {}
    
    func call(arguments: Arguments) async throws -> String {
        var content = """
        Name: \(userData.name)
        Current Balance: $\(String(format: "%.2f", userData.balance))
        Next Income: \(userData.nextIncomeTime)
        """
        
        if let income = userData.recurringIncomeAmount {
            content += "\nRecurring Income: $\(String(format: "%.2f", income))"
        }
        
        return content
    }
}


final class AnalyseRecentTransactionsTool: Tool {
    var name: String { "analyseTransactions" }
    var description: String { "Analyse user's transactions, optionally filtered by category, for identification of spending patterns" }
    
    private let userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
    }
    
    @Generable
    struct Arguments {
        @Guide(description: "Optional category to filter by. Leave empty to analyze everything")
        let category: String?
    }
    
    func call(arguments: Arguments) async throws -> String {
        let transactions: [Transaction]

        if let categoryName = arguments.category?.lowercased() {
            transactions = userData.transactions.filter {
                $0.transactionCategory.rawValue.lowercased().contains(categoryName)
            }
        } else {
            transactions = userData.transactions
        }
        
        guard !transactions.isEmpty else {
            return "No transactions found" +
            (arguments.category != nil ? " for category: \(arguments.category)" : "")
        }
        
        // Calculate statistics
        let total = transactions.reduce(0.0) { $0 + $1.transactionAmount }
        let average = total / Double(transactions.count)
        let max = transactions.map { $0.transactionAmount }.max() ?? 0
        let min = transactions.map { $0.transactionAmount }.min() ?? 0
        
        // Group by category
        let byCategory = Dictionary(grouping: transactions) { $0.transactionCategory }
        
        var content = """
        Transaction Analysis:
        - Total Spent: $\(String(format: "%.2f", total))
        - Transaction Count: \(transactions.count)
        - Average Transaction: $\(String(format: "%.2f", average))
        - Largest Transaction: $\(String(format: "%.2f", max))
        - Smallest Transaction: $\(String(format: "%.2f", min))
        
        Breakdown by Category:
        """
        
        for (category, items) in byCategory.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
            let categoryTotal = items.reduce(0.0) { $0 + $1.transactionAmount }
            let percentage = (categoryTotal / total) * 100
            content += "\n- \(category.rawValue): $\(String(format: "%.2f", categoryTotal)) (\(String(format: "%.1f", percentage))%)"
        }
        
        // Find top 5 transactions
        let topTransactions = transactions
            .sorted { $0.transactionAmount > $1.transactionAmount }
            .prefix(5)
        
        content += "\n\nTop Expenses:"
        for (index, transaction) in topTransactions.enumerated() {
            content += "\n\(index + 1). \(transaction.transactionName) - $\(String(format: "%.2f", transaction.transactionAmount)) (\(transaction.transactionCategory.rawValue))"
        }
        
        return content
    }
}

final class AnalyseSubscriptionTool: Tool {
    var name: String { "analyseSubscriptions" }
    var description: String { "Analyse subscriptions and calculate montly stats" }
    
    private let userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
    }
    
    @Generable
    struct Arguments {}
    
    func call(arguments: Arguments) async throws -> String {
        guard !userData.subscriptions.isEmpty else {
            return "No active subscriptions found."
        }
        
        // Calculate costs in different timeframes
        var monthlyTotal = 0.0
        var yearlyTotal = 0.0
        
        var breakdown = "Active Subscriptions:\n"
        
        for subscription in userData.subscriptions.sorted(by: { $0.subscriptionName < $1.subscriptionName }) {
            let monthlyEquivalent: Double
            
            switch subscription.subscriptionType {
            case .monthly:
                monthlyEquivalent = subscription.price
            case .annually:
                monthlyEquivalent = subscription.price / 12.0
            }
            
            monthlyTotal += monthlyEquivalent
            yearlyTotal += monthlyEquivalent * 12
            
            breakdown += "\n- \(subscription.subscriptionName): $\(String(format: "%.2f", subscription.price))/\(subscription.subscriptionType.rawValue) (≈$\(String(format: "%.2f", monthlyEquivalent))/month)"
        }
        
        return """
        \(breakdown)
        
        Summary:
        - Total Subscriptions: \(userData.subscriptions.count)
        - Monthly Cost: $\(String(format: "%.2f", monthlyTotal))
        - Yearly Cost: $\(String(format: "%.2f", yearlyTotal))
        - Average per Subscription: $\(String(format: "%.2f", monthlyTotal / Double(userData.subscriptions.count)))/month
        """
    }
}

final class GetSpendingInsightsTotalTool: Tool {
    var name: String { "getSpendingInsights" }
    var description: String { "Get total spending insights and identify financial health indicators" }
    
    private let userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
    }
    
    @Generable
    struct Arguments {
        @Guide(description: "Number of days to analyze. Defaults to 30 if not specified.")
        let days: Int?
    }
    
    func call(arguments: Arguments) async throws -> String {
        let daysToAnalyze = arguments.days ?? 30
        
        let totalSpending = userData.transactions.reduce(0.0) { $0 + $1.transactionAmount }
        
        let subscriptionCostForPeriod = userData.subscriptions.reduce(0.0) { total, subscription in
            let dailyCost: Double
            switch subscription.subscriptionType {
            case .monthly:
                dailyCost = subscription.price / 30.0
            case .annually:
                dailyCost = subscription.price / 365.0
            }
            return total + (dailyCost * Double(daysToAnalyze))
        }
        
        let totalExpenses = totalSpending + subscriptionCostForPeriod
        
        var insights = """
        Financial Insights (Last \(daysToAnalyze) days):
        
        Expenses:
        - Transactions: $\(String(format: "%.2f", totalSpending))
        - Subscriptions: $\(String(format: "%.2f", subscriptionCostForPeriod))
        - Total Expenses: $\(String(format: "%.2f", totalExpenses))
        """
        
        if let income = userData.recurringIncomeAmount {
            let projectedIncome = (income / 30.0) * Double(daysToAnalyze)
            let netCashFlow = projectedIncome - totalExpenses
            let savingsRate = (netCashFlow / projectedIncome) * 100
            
            insights += """
            
            
            Income Analysis:
            - Projected Income: $\(String(format: "%.2f", projectedIncome))
            - Net Cash Flow: $\(String(format: "%.2f", netCashFlow))
            - Savings Rate: \(String(format: "%.1f", savingsRate))%
            
            Health Indicators:
            """
            
            if savingsRate >= 20 {
                insights += "\n✓ Excellent savings rate (20%+ target)"
            } else if savingsRate >= 10 {
                insights += "\n⚠ Moderate savings rate (aim for 20%+)"
            } else if savingsRate > 0 {
                insights += "\n⚠ Low savings rate (below 10%)"
            } else {
                insights += "\n✗ Spending exceeds income - immediate action needed"
            }
            
            let expenseRatio = (totalExpenses / projectedIncome) * 100
            insights += "\n- Expense Ratio: \(String(format: "%.1f", expenseRatio))% of income"
        }
        
        if userData.balance < totalExpenses {
            insights += "\n\n⚠ Warning: Current balance is lower than recent monthly expenses"
        }
        
        return insights
    }
}
