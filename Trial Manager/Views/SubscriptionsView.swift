//
//  SubscriptionsView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 21/1/26.
//

import SwiftUI

struct SubscriptionsView: View {
    @Binding var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    @State var searchTerm: String = ""
    @Environment(\.dismiss) var dismiss
    @State var selectedSubscription: Subscription? = nil
    
    func subscriptionItem(_ subscription: Subscription) -> some View {
        HStack {
            Image(systemName: subscription.subscriptionIcon)
                .foregroundStyle(.white)
                .padding()
                .background {
                    Circle()
                        .fill(Color.accent)
                }
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(subscription.subscriptionName)
                    .font(.title2)
                if subscription.freeTrial {
                    Text("Free trial - Ends on \(subscription.freeTrialEndDate?.formatted(date: .numeric, time: .omitted) ?? "N/A")")
                        .font(.caption)
                        .italic()
                } else {
                    Text("Next renewal at \(subscription.nextCycle.formatted(date: .numeric, time: .omitted))")
                        .font(.footnote)
                        .italic()
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(subscription.price, format: .currency(code: "USD"))
                if subscription.subscriptionType == .annually {
                    Text("per year")
                        .font(.caption)
                        .italic()
                } else if subscription.subscriptionType == .monthly {
                    Text("per month")
                        .font(.caption)
                        .italic()
                }
            }
            
        }
        .padding()
        .glassEffect()
        .sheet(item: $selectedSubscription) { subscriptionItem in
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: subscription.subscriptionIcon)
                        .foregroundStyle(.white)
                        .padding()
                        .background {
                            Circle()
                                .fill(Color.accent)
                        }
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text(subscription.subscriptionName)
                            .font(.title2)
                    }
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .adaptiveProminentButtonStyle()
                }
                HStack {
                    if subscription.freeTrial {
                        Text("Free trial - Ends on \(subscription.freeTrialEndDate?.formatted(date: .numeric, time: .omitted) ?? "N/A")")
                            .font(.caption)
                            .italic()
                    } else {
                        Text("Next renewal at \(subscription.nextCycle.formatted(date: .numeric, time: .omitted))")
                            .font(.body)
                    }
                    Spacer()
                    VStack {
                        Text(subscription.price, format: .currency(code: "USD"))
                        
                        if subscription.subscriptionType == .annually {
                            
                            Text("per year")
                                .font(.caption)
                                .italic()
                        } else if subscription.subscriptionType == .monthly {
                            Text("per month")
                                .font(.caption)
                                .italic()
                        }
                    }
                }
                Button {
                    for subscription in userData.subscriptions {
                        if subscription.id == subscriptionItem.id {
                            userData.subscriptions.removeAll(where: { $0.id == subscription.id })
                        }
                    }
                } label: {
                    Spacer()
                    Image(systemName: "xmark.circle")
                    Text("Cancel Subscription")
                    Spacer()
                }
                .adaptiveProminentButtonStyle()
            }
            .padding()
            .presentationDetents([.fraction(0.3)])
            
        }
        .onTapGesture {
            selectedSubscription = subscription
        }
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.accentColor.opacity(0.2)
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        Text("Subscriptions")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(Color.accentColor)
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search for subscriptions...", text: $searchTerm)
                        }
                        .padding()
                        .glassEffect()
                        
                            ViewThatFits {
                                VStack(alignment: .leading) {
                                    ForEach(userData.subscriptions, id: \.id) { transaction in
                                        subscriptionItem(transaction)
                                    }
                                }
                                
                                ScrollView {
                                    VStack(alignment: .center) {
                                        ForEach(userData.subscriptions, id: \.id) { transaction in
                                            subscriptionItem(transaction)
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
    SubscriptionsView(userData: .constant(UserData.freelancer()))
}
