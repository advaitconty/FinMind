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
                VStack(alignment: .leading) {
                    Text(transaction.transactionName)
                    Text("$\(String(format: "%.2f", transaction.transactionAmount))")
                }
                Spacer()
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
                    }
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(Color.accentColor)
                    
                    VStack {
                        ViewThatFits {
                            VStack(alignment: .leading) {
                                ForEach(userData.transactions, id: \.id) { transaction in
                                    transactionListItem(transaction)
                                }
                            }
                            
                            ScrollView {
                                VStack(alignment: .center, spacing: 0) {
                                    ForEach(userData.transactions, id: \.id) { transaction in
                                        transactionListItem(transaction)
                                    }
                                }
                            }
                        }
                        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
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
