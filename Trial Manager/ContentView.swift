
//
//  ContentView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/12/25.
//

import SwiftUI

enum SelectedTab: Codable {
    case home, transactions, receipts, settings, transact
}

struct ContentView: View {
    @State var selectedTab: SelectedTab = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            // To be added along with recieipts
            //            Tab("Receipts", systemImage: "receipt", value: .home) {
            //                Text("Home")
            //            }
            
            
            Tab("Home", systemImage: "house", value: .home) {
                Text("Home")
            }
            
            // To be added along with recieipts
            //            Tab("New Log", systemImage: "minus.forwardslash.plus", value: .transact) {
            //                Text("View transactions")
            //            }
            
            Tab("Ledger", systemImage: "book.pages", value: .transactions) {
                Text("View transactions")
            }
            
            
            Tab("Settings", systemImage: "gearshape.2", value: .settings) {
                Text("Settings")
            }
        }
    }
}

#Preview {
    ContentView()
}
