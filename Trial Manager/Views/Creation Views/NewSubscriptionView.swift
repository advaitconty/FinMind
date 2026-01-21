//
//  NewSubscriptionView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 21/1/26.
//

// MARK: TODO
/// finish this view tmw

import SwiftUI
import SymbolPicker

struct NewSubscriptionView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var transactionName: String = ""
    @State var amountSpent: Double = 0.0
    @State var moneyEarnt: Bool = false
    @State var transactionType: TransactionType = .essential
    @State var transactionSymbol: String = "creditcard"
    @State var showSymbolSelector: Bool = false
    @State var newTransactionColor: Color = .blue
    @Binding var userData: UserData
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.accentColor.opacity(0.2)
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: transactionSymbol)
                            .onTapGesture {
                                showSymbolSelector = true
                            }
                            .foregroundStyle(.white)
                        
                        Text(transactionName.isEmpty ? "New Transaction" : transactionName)
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                        .adaptiveButtonStyle()
                    }
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(Color.accentColor)
                    
                    VStack {
                        HStack {
                            Text("Name:")
                            TextField("Groceries...", text: $transactionName)
                        }
                        .padding()
                        .glassEffect()
                        
                        HStack {
                            Text("Amount:")
                            TextField("Groceries...", value: $amountSpent, format: .currency(code: "SGD"))
                        }
                        .padding()
                        .glassEffect()
                        
                        Picker("", selection: $moneyEarnt) {
                            HStack {
                                Text("Expense")
                            }
                            .tag(false)
                            HStack {
                                Text("Income")
                            }
                            .tag(true)
                        }
                        .pickerStyle(.segmented)
                        
                        HStack {
                            Text("Transaction Type")
                            Spacer()
                            Picker("Transaction Type", selection: $transactionType) {
                                ForEach(TransactionType.pickerOptions(isIncomeMode: moneyEarnt), id: \.self) {
                                    Text($0.rawValue)
                                        .tag($0)
                                }
                            }
                            .tint(.accentColor)
                        }
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom], 10)
                        .glassEffect()
                        
                        HStack {
                            Text("Icon background color")
                            Spacer()
                            ColorPicker("", selection: $newTransactionColor)
                        }
                        .padding()
                        .glassEffect()
                        
                        HStack {
                            Text("Transaction Icon")
                            Spacer()
                            Button {
                                showSymbolSelector = true
                            } label: {
                                Image(systemName: transactionSymbol)
                            }
                            .adaptiveProminentButtonStyle()
                            .tint(newTransactionColor)
                        }
                        .padding()
                        .glassEffect()
                        
                        Button {
                            userData.transactions.append(Transaction(timeOfTransaction: Date(), transactionName: transactionName, transactionIcon: transactionSymbol, transactionAmount: amountSpent, receiptImagePath: nil, iconBackgroundColor: newTransactionColor, transactionCategory: transactionType, additionToBankAccount: moneyEarnt))
                            if moneyEarnt {
                                userData.balance += amountSpent
                            } else {
                                userData.balance -= amountSpent
                            }
                            dismiss()
                        } label: {
                            Spacer()
                            Image(systemName: "book.badge.plus")
                            Text("Add transaction")
                            Spacer()
                        }
                        .adaptiveProminentButtonStyle()
                        
                    }
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(colorScheme == .dark ? .black : .white)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .padding()
                .frame(maxWidth: reader.size.width - 20, maxHeight: reader.size.height)
                .fullScreenCover(isPresented: $showSymbolSelector) {
                    SymbolPicker(symbol: $transactionSymbol)
                }
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NewSubscriptionView(userData: .constant(UserData.freelancer()))
}
