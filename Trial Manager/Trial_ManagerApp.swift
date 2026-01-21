//
//  Trial_ManagerApp.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/12/25.
//

import SwiftUI
import SwiftData

let appName: String = "FinMinder"

@main
struct Trial_ManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: UserData.self)
        }
    }
}
