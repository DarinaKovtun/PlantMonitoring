//
//  RootView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 31.05.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        if authVM.isLoggedIn {
            TabView {
                PlantListView()
                    .tabItem { Label("Рослини", systemImage: "leaf") }
                StatisticsView()
                    .tabItem { Label("Статистика", systemImage: "chart.bar") }
                SettingsView()
                    .tabItem { Label("Налаштування", systemImage: "gear") }
            }
        } else {
            NavigationView {
                LoginView()
            }
        }
    }
}

