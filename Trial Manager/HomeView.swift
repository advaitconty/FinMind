//
//  HomeView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 19/1/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var userData: UserData
    @State var openedTransaction: Transaction? = nil
    @State var newTransactionView: Bool = false
    
    func transactionListItem(_ transaction: Transaction) -> some View {
        Button {
            openedTransaction = transaction
        } label: {
            HStack(spacing: 10) {
                Image(systemName: transaction.transactionIcon)
                    .padding()
                    .background {
                        Circle()
                            .fill(Color(
                                red: Double.random(in: 0...1),
                                green: Double.random(in: 0...1),
                                blue: Double.random(in: 0...1),
                                opacity: true ? Double.random(in: 0...1) : 1
                            ))
                    }
                VStack(alignment: .leading) {
                    Text(transaction.transactionName)
                    Text("$\(String(format: "%.2f", transaction.transactionAmount))")
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .glassEffect()
        }
        .buttonStyle(.plain)
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Color.accentColor.opacity(0.2)
                    VStack(spacing: 0) {
                        VStack {
                            Text("Welcome back to \(appName), \(userData.name)!")
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .frame(minWidth: reader.size.width - 20)
                        .background(colorScheme == .dark ? .black : .white)
                        
                        VStack {
                            Text("$\(String(format: "%.2f", userData.balance)) ")
                                .font(.largeTitle)
                                .fontWidth(.expanded)
                            Text("balance available")
                        }
                        .padding()
                        .frame(minWidth: reader.size.width - 20)
                        .background(Color.accentColor)
                        
                        VStack {
                            Text("TODAY'S TRANSACTIONS")
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                
                Button {
                    newTransactionView = true
                } label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                }
                .adaptiveProminentButtonStyle()
                .padding()
                .sheet(isPresented: $newTransactionView) {
                    NewTransactionView()
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
}

#Preview {
    HomeView(userData: .constant(UserData.monthlySalaryEmployee()))
}
