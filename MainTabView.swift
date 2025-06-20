//
//  MainTabView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import SwiftUI

struct MainTabView: View {
    let userEmail = "mary@gmail.com"
    var userId: String {
        userEmail.replacingOccurrences(of: ".", with: "_")
    }

    var body: some View {
        TabView {
            PlantsView(userId: userId)
                .tabItem { Label("Рослини", systemImage: "leaf") }
            StatsView(userId: userId)
                .tabItem { Label("Статистика", systemImage: "chart.bar") }
            Text("⚙️ Налаштування").tabItem { Label("Налаштування", systemImage: "gear") }
        }
    }
}


