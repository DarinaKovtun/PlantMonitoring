//
//  MainTabView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import SwiftUI
import FirebaseAuth

struct MainTabView: View {
    var userId: String {
        Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "_") ?? "unknown_user"
    }

    var body: some View {
        TabView {
            PlantsView(userId: userId)
                .tabItem { Label("Рослини", systemImage: "leaf") }

            StatsView(userId: userId)
                .tabItem { Label("Статистика", systemImage: "chart.bar") }

            SettingsView(userId: userId)
                .tabItem { Label("Налаштування", systemImage: "gear") }
        }
    }
}

   

