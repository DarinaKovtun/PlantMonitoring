//
//  GreenMonitoringApp.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 30.05.2025.
//

import SwiftUI
import Firebase

@main
struct GreenMonitoringApp: App {
    @StateObject var authVM = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}

