//
//  TransactionsView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/1/26.
//

import SwiftUI

struct TransactionsView: View {
    @Binding var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    @State var searchText: String = ""
    
    var filteredTransactions: [Transaction] {
        if searchText.isEmpty {
            return userData.transactions
        }

        return userData.transactions.filter { transaction in
            transaction.transactionName.localizedCaseInsensitiveContains(searchText)
            || String(format: "%.2f", transaction.transactionAmount).contains(searchText)
        }
    }
    
    var groupedTransactions: [(date: Date, transactions: [Transaction])] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: filteredTransactions) {
            calendar.startOfDay(for: $0.timeOfTransaction)
        }

        return grouped
            .map { (date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }

    func sectionTitle(for date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
    
    func transactionListItem(_ transaction: Transaction) -> some View {
        Button {
//            openedTransaction = transaction
        } label: {
            HStack(spacing: 10) {
                Image(systemName: transaction.transactionIcon)
                    .padding()
                    .background {
                        Circle()
                            .fill(transaction.iconBackgroundColor)
                    }
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(transaction.transactionName)
                    Text("$\(String(format: "%.2f", transaction.transactionAmount))")
                }
                Spacer()
                if transaction.additionToBankAccount{
                    Image(systemName: "plus")
                } else {
                    Image(systemName: "minus")
                }
//                Image(systemName: "chevron.right")
            }
            .padding()
            .glassEffect()
        }
        .buttonStyle(.plain)
    }

    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.accentColor.opacity(0.2)
                VStack(spacing: 0) {
                    VStack {
                        Text("Transaction History")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(Color.accentColor)
                    
                    VStack {
                        if !groupedTransactions.isEmpty {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search through your history...", text: $searchText)
                        }
                        .padding()
                        .glassEffect()
                        
                            ViewThatFits {
                                VStack(alignment: .leading) {
                                    ForEach(groupedTransactions, id: \.date) { group in
                                        VStack(alignment: .leading, spacing: 8) {
                                            
                                            // Date header
                                            Text(sectionTitle(for: group.date))
                                                .font(.headline)
                                                .padding(.horizontal)
                                            
                                            // Transactions for that day
                                            ForEach(group.transactions, id: \.id) { transaction in
                                                transactionListItem(transaction)
                                            }
                                        }
                                    }
                                    
                                }
                                
                                ScrollView {
                                    VStack(alignment: .center, spacing: 0) {
                                        ForEach(groupedTransactions, id: \.date) { group in
                                            VStack(alignment: .leading, spacing: 8) {
                                                
                                                // Date header
                                                Text(sectionTitle(for: group.date))
                                                    .font(.headline)
                                                    .padding(.horizontal)
                                                
                                                // Transactions for that day
                                                ForEach(group.transactions, id: \.id) { transaction in
                                                    transactionListItem(transaction)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
                        } else {
                            Text("No transaction history found! Please start by adding a transaction to see it here.")
                        }
                    }
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(colorScheme == .dark ? .black : .white)
                }
                
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .padding()
                .frame(maxWidth: reader.size.width - 20, maxHeight: reader.size.height)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TransactionsView(userData: .constant(UserData.monthlySalaryEmployee()))
}
