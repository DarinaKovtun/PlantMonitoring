//
//  SettingsView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 20.06.2025.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    let userId: String
    @AppStorage("notificationsEnabled") var notificationsEnabled = true
    @EnvironmentObject var authVM: AuthViewModel

    @State private var showLogoutAlert = false
    @State private var showPasswordResetAlert = false
    @State private var userEmail: String = ""
    @State private var resetMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                // Обліковий запис
                Section(header: Text("Обліковий запис")) {
                    Text("Пошта: \(userEmail)")
                        .font(.subheadline)
                    Button("Змінити пароль") {
                        sendPasswordReset()
                    }
                    .alert("Повідомлення", isPresented: $showPasswordResetAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(resetMessage)
                    }
                }

                // Сповіщення
                Section(header: Text("Сповіщення")) {
                    Toggle("Увімкнути сповіщення", isOn: $notificationsEnabled)
                }

                // Вихід
                Section {
                    Button("Вийти з акаунту", role: .destructive) {
                        showLogoutAlert = true
                    }
                }
            }
            .navigationTitle("⚙️ Налаштування")
            .alert("Вийти з акаунту?", isPresented: $showLogoutAlert) {
                Button("Так", role: .destructive) {
                    do {
                        try Auth.auth().signOut()
                        authVM.isLoggedIn = false
                    } catch {
                        print("❌ Помилка виходу: \(error.localizedDescription)")
                    }
                }
                Button("Скасувати", role: .cancel) { }
            }
            .onAppear {
                userEmail = Auth.auth().currentUser?.email ?? "Невідомо"
            }
        }
    }

    private func sendPasswordReset() {
        guard let email = Auth.auth().currentUser?.email else {
            resetMessage = "Не вдалося отримати адресу електронної пошти."
            showPasswordResetAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                resetMessage = "Помилка: \(error.localizedDescription)"
            } else {
                resetMessage = "Інструкція для зміни пароля надіслана на \(email)"
            }
            showPasswordResetAlert = true
        }
    }
}
