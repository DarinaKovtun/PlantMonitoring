//
//  ContentView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 30.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authVM = AuthViewModel() 
    @State private var isSplashActive = true
    @State private var showRegister = false

    var body: some View {
        if authVM.isLoggedIn {
            MainTabView()
                .environmentObject(authVM)
        } else {
            if isSplashActive {
                SplashScreenView(isActive: $isSplashActive)
            } else {
                if showRegister {
                    RegisterView(showRegister: $showRegister)
                        .environmentObject(authVM)
                } else {
                    LoginView(showRegister: $showRegister)
                        .environmentObject(authVM)
                }
            }
        }
    }
}
