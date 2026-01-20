//
//  NewTransactionView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/1/26.
//

import SwiftUI
import SymbolPicker

struct NewTransactionView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var transactionName: String = ""
    @State var amountSpent: Double = 0.0
    @State var moneyEarnt: Bool = false
    @State var transactionType: TransactionType = .essential
    @State var transactionSymbol: String = "creditcard"
    @State var showSymbolSelector: Bool = false
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
                        
                            .popover(isPresented: $showSymbolSelector, arrowEdge: .trailing) {
                            SymbolPicker(symbol: $transactionSymbol)
                                .presentationDetents([.medium, .large])
                        }
                        Text(transactionName.isEmpty ? "New Transaction" : transactionName)
                            .font(.title)
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
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
                            Picker("", selection: $transactionType) {
                                Text("Essentials")
                                    .tag(TransactionType.essential)
                                Text("Facilities")
                                    .tag(TransactionType.facilities)
                                Text("Food")
                                    .tag(TransactionType.food)
                                Text("Rent")
                                    .tag(TransactionType.rent)
                                Text("Shoppping")
                                    .tag(TransactionType.shopping)
                                Text("Utilities")
                                    .tag(TransactionType.utilities)
                                Text("Other")
                                    .tag(TransactionType.other)
                            }
                            .tint(.accentColor)
                        }
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom], 10)
                        .glassEffect()
                        
                        Button {
                            
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
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NewTransactionView()
}
