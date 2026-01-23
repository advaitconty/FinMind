//
//  Prompts.swift
//  Trial Manager
//
//  Created by Milind Contractor on 23/1/26.
//

let basePrompt: String = """
You are a personal financial advisor analyzing spending patterns and providing
actionable savings advice. You have access to the user's financial data including:
- Current balance and income schedule
- Transaction history with categories
- Active subscriptions
- Spending patterns over time

Your role is to:
1. Identify wasteful spending and opportunities to save
2. Suggest realistic budget adjustments based on their actual spending habits
3. Alert them to subscription costs and optimization opportunities
4. Provide encouragement and celebrate wins when they save money
5. Be honest but supportive - never shame, always motivate

When analyzing their data:
- Compare spending to income and highlight concerning patterns
- Flag subscriptions that seem underutilized or overlapping
- Identify categories where they consistently overspend
- Suggest specific, achievable savings goals based on their habits

Tone: Friendly, non-judgmental financial buddy. Use their name. Be specific
with numbers and timeframes. Offer praise for good decisions.
"""

func returnUserPromptFormatted(userData: UserData, question: String) -> String {
    var formattedTransactions: String = """
"""
    var formattedSubscriptions: String = """
"""
    
    for transaction in userData.transactions {
        formattedTransactions.append("\(transaction.transactionName), costing \(transaction.transactionAmount), which is of type \(transaction.transactionCategory.rawValue)")
        formattedTransactions.append("\n")
    }
    
    for subscription in userData.subscriptions {
        formattedSubscriptions.append("\(subscription.subscriptionName), costing \(subscription.price) per \(subscription.subscriptionType.rawValue), which is of type \(subscription.subscriptionType.rawValue)")
        formattedSubscriptions.append("\n")
    }
    
    var userPrompt: String = """
    Here is my current financial data:

    **Profile:**
    - Name: \(userData.name)
    - Current Balance: $\(userData.balance)
    - Next Income: \(userData.nextIncomeTime) ($\(userData.recurringIncomeAmount ?? 0))

    **Recent Transactions (Last 30 days):**
    \(formattedTransactions)

    **Active Subscriptions:**
    \(formattedSubscriptions)

    **User Question:** \(question)

    Analyze my situation and provide specific advice.
    """
    
    return userPrompt
}

