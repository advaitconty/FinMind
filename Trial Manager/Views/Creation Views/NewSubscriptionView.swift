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
    @State var noNotificationsGiven: Bool = false
    @State var subscriptionType: SubscriptionType = .monthly
    @State var showSymbolSelector: Bool = false
    @State var subscriptionColor: Color = .blue
    @State var wantsFreeTrialEndingReminder: Bool = true
    @Binding var userData: UserData
    @State var incompleteInformationError: Bool = false
    @Environment(\.openURL) var openURL
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
                            let calender = Calendar.current
                            if !transactionName.isEmpty && moneyCharged != 0.0 || (freeTrial && freeTrialEndDate == Date() && !transactionName.isEmpty && moneyCharged != 0.0) {
                                if freeTrial {
                                    if wantsFreeTrialEndingReminder {
                                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                            if success {
                                                userData.notificationsPermissionGiven = true
                                                
                                                let content = UNMutableNotificationContent()
                                                content.title = "Free trial for \(transactionName) ends in 1 day"
                                                content.subtitle = "Please cancel it in time (and from FinMinder) to ensure you do not incur any unintended charges, unless you plan on continuing the subscription."
                                                content.sound = .default
                                                
                                                guard let dayBefore = calender.date(byAdding: .day,value: -1, to: freeTrialEndDate) else { return }
                                                
                                                var components = calender.dateComponents(
                                                    [.year, .month, .day], from: dayBefore)
                                                
                                                components.hour = 15
                                                components.minute = 0
                                                components.second = 30
                                                
                                                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                                
                                                UNUserNotificationCenter.current().add(request)
                                                
                                                if subscriptionType == .annually {
                                                    userData.subscriptions.append(Subscription(subscriptionName: transactionName, subscriptionIcon: subscriptionSymbol, subscriptionType: .annually, price: moneyCharged, nextCycle: freeTrialEndDate, freeTrial: true, freeTrialEndDate: freeTrialEndDate, subscriptionColor: subscriptionColor, wantsReminderwhenFreeTrialExpires: true, subscriptionPriority: subscriptionPriority))
                                                } else {
                                                    userData.subscriptions.append(Subscription(subscriptionName: transactionName, subscriptionIcon: subscriptionSymbol, subscriptionType: .monthly, price: moneyCharged, nextCycle: freeTrialEndDate, freeTrial: true, freeTrialEndDate: freeTrialEndDate, subscriptionColor: subscriptionColor, wantsReminderwhenFreeTrialExpires: true, subscriptionPriority: subscriptionPriority))
                                                }
                                            } else {
                                                userData.notificationsPermissionGiven = false
                                                noNotificationsGiven = true
                                            }
                                        }
                                    } else {
                                        if subscriptionType == .annually {
                                            userData.subscriptions.append(Subscription(subscriptionName: transactionName, subscriptionIcon: subscriptionSymbol, subscriptionType: .annually, price: moneyCharged, nextCycle: freeTrialEndDate, freeTrial: true, freeTrialEndDate: freeTrialEndDate, subscriptionColor: subscriptionColor, subscriptionPriority: subscriptionPriority))
                                        } else {
                                            userData.subscriptions.append(Subscription(subscriptionName: transactionName, subscriptionIcon: subscriptionSymbol, subscriptionType: .monthly, price: moneyCharged, nextCycle: freeTrialEndDate, freeTrial: true, freeTrialEndDate: freeTrialEndDate, subscriptionColor: subscriptionColor, subscriptionPriority: subscriptionPriority))
                                        }
                                    }
                                } else {
                                    if subscriptionType == .annually {
                                        let nextCycleDate: Date = calender.date(byAdding: .year, value: 1, to: Date())!
                                        userData.subscriptions.append(Subscription(subscriptionName: transactionName, subscriptionIcon: subscriptionSymbol, subscriptionType: .annually, price: moneyCharged, nextCycle: nextCycleDate, subscriptionColor: subscriptionColor, subscriptionPriority: subscriptionPriority))
                                    } else {
                                        let nextCycleDate: Date = calender.date(byAdding: .month, value: 1, to: Date())!
                                        userData.subscriptions.append(Subscription(subscriptionName: transactionName, subscriptionIcon: subscriptionSymbol, subscriptionType: .monthly, price: moneyCharged, nextCycle: nextCycleDate, subscriptionColor: subscriptionColor, subscriptionPriority: subscriptionPriority))
                                    }
                                }
                                dismiss()
                            } else {
                                incompleteInformationError = true
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
                .alert("Incomplete information", isPresented: $incompleteInformationError) {
                    Text("Please ensure all details are provided before continuing")
                    Button { } label: { Text("OK") }
                    
                }
                .alert("Cannot show notification for end of free trial", isPresented: $noNotificationsGiven) {
                    Text("You haven't given this app notification permissions yet. Please enable  it in settings")
                    Button { } label: { Text("OK") }
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            openURL(url)
                        }
                    } label: { Text("Bring me to settings") }
                }
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NewSubscriptionView(userData: .constant(UserData.freelancer()))
}
