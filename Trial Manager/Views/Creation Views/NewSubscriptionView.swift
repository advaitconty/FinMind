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
    @State var moneyCharged: Double = 0.0
    @State var freeTrial: Bool = false
    @State var freeTrialEndDate: Date = Date()
    @State var subscriptionPriority: SubscriptionPriority = .important
    @State var subscriptionSymbol: String = "dollarsign.arrow.trianglehead.counterclockwise.rotate.90"
    @State var subscriptionType: SubscriptionType = .monthly
    @State var showSymbolSelector: Bool = false
    @State var subscriptionColor: Color = .blue
    @State var wantsFreeTrialEndingReminder: Bool = true
    @Binding var userData: UserData
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.accentColor.opacity(0.2)
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: subscriptionSymbol)
                            .onTapGesture {
                                showSymbolSelector = true
                            }
                            .foregroundStyle(.white)
                        
                        Text(transactionName.isEmpty ? "New Subscription" : transactionName)
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                        .adaptiveProminentButtonStyle()
                    }
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(Color.accentColor)
                    
                    VStack {
                        HStack {
                            Text("Name:")
                            TextField("YouTube Premium...", text: $transactionName)
                        }
                        .padding()
                        .glassEffect()
                        
                        HStack {
                            Text("Charge per cycle:")
                            TextField("Groceries...", value: $moneyCharged, format: .currency(code: "SGD"))
                        }
                        .padding()
                        .glassEffect()
                        
                        HStack {
                            Picker("", selection: $subscriptionType) {
                                Text("Annual")
                                    .tag(SubscriptionType.annually)
                                Text("Monthly")
                                    .tag(SubscriptionType.monthly)
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        HStack {
                            Text("Includes free trial")
                            Spacer()
                            Toggle("", isOn: $freeTrial)
                        }
                        .padding()
                        .glassEffect()
                        
                        if freeTrial {
                            HStack {
                                Text("Free trial end date")
                                Spacer()
                                DatePicker("", selection: $freeTrialEndDate, in: Calendar.current.date(byAdding: .day, value: 1, to: Date())!..., displayedComponents: .date)
                            }
                            .padding()
                            .glassEffect()
                            
                                HStack {
                                    Text("Free trial end reminder")
                                    Spacer()
                                    Toggle("", isOn: $wantsFreeTrialEndingReminder)
                                        .labelsHidden()
                                }
                    .disabled(!userData.notificationsPermissionGiven)
                    .padding()
                    .glassEffect()
                            
                            VStack(alignment: .leading) {
                                Text("Enabling this will give you a notification 1 day before the free trial period ends. \(!userData.notificationsPermissionGiven ? "You cannot enable this as notification permissions have not been given." : "" )")
                                    .italic()
                                    .font(.caption)
                                    .onAppear {
                                        if !userData.notificationsPermissionGiven {
                                            wantsFreeTrialEndingReminder = false
                                        }
                                    }
                                
                            }
                            .padding()
                            .glassEffect()
                        }
                        
                        HStack {
                            Text("Subscription Type")
                            Spacer()
                            Picker("Subscription Type", selection: $subscriptionPriority) {
                                ForEach(SubscriptionPriority.allCases, id: \.self) {
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
                            HStack {
                                Text("Icon background color")
                                ColorPicker("", selection: $subscriptionColor)
                                    .labelsHidden()
                            }
                            .padding()
                            .glassEffect()
                            
                            HStack {
                                Text("Subscription icon")
                                Spacer()
                                Button {
                                    showSymbolSelector = true
                                } label: {
                                    Image(systemName: subscriptionSymbol)
                                }
                                .adaptiveProminentButtonStyle()
                                .tint(subscriptionColor)
                            }
                            .padding()
                            .glassEffect()
                        }
                        
                        Button {
                            if userData.notificationsPermissionGiven {
                                dismiss()
                            } else {
                                
                            }
                        } label: {
                            Spacer()
                            Image(systemName: "bag.badge.plus")
                            Text("Add Subscription")
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
                    SymbolPicker(symbol: $subscriptionSymbol)
                }
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NewSubscriptionView(userData: .constant(UserData.freelancer()))
}
