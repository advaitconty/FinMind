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
    var body: some View {
        GeometryReader { reader in
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
                                ForEach(1...30, id: \.self) { _ in
                                    Text("Hello")
                                    Text("Hello")
                                }
                            }

                            ScrollView {
                                VStack(alignment: .leading) {
                                    ForEach(1...30, id: \.self) { _ in
                                        Text("Hello")
                                        Text("Hello")
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
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding()
                .frame(maxWidth: reader.size.width - 20)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView(userData: .constant(UserData.monthlySalaryEmployee()))
}
