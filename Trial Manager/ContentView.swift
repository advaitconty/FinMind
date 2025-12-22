
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
            Tab("Receipts", systemImage: "receipt", value: .home) {
                Text("Home")
            }
            
            Tab("New Log", systemImage: "minus.forwardslash.plus", value: .transact) {
                Text("View transactions")
            }

            Tab("Home", systemImage: "house", value: .home) {
                Text("Home")
            }
            
            Tab("Logs", systemImage: "list.dash", value: .transactions) {
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
