//
//  AuthViewModel.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    // Стан авторизації
    @Published var isLoggedIn = false

    // Поля для відображення помилок
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var usernameError = ""
    @Published var confirmPasswordError = ""

    // Вхід
    func login(email: String, password: String) {
        clearErrors()
        var hasError = false

        if !email.contains("@") {
            emailError = "Некоректний email (має містити @)"
            hasError = true
        }

        if password.count < 8 {
            passwordError = "Пароль має містити щонайменше 8 символів"
            hasError = true
        }

        guard !hasError else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let err = error as NSError?, let code = AuthErrorCode.Code(rawValue: err.code) {
                    switch code {
                    case .userNotFound:
                        self?.emailError = "Ця пошта не зареєстрована"
                    case .wrongPassword:
                        self?.passwordError = "Невірний пароль"
                    default:
                        self?.emailError = "Помилка: \(err.localizedDescription)"
                    }
                } else {
                    // Успішний вхід
                    self?.isLoggedIn = true
                }
            }
        }
    }

    // Реєстрація
    func register(email: String, password: String, confirmPassword: String, username: String) {
        clearErrors()
        var hasError = false

        if username.trimmingCharacters(in: .whitespaces).isEmpty {
            usernameError = "Ім'я користувача не може бути порожнім"
            hasError = true
        }

        if !email.contains("@") {
            emailError = "Некоректний email (має містити @)"
            hasError = true
        }

        if password.count < 8 {
            passwordError = "Пароль має містити щонайменше 8 символів"
            hasError = true
        }

        if confirmPassword != password {
            confirmPasswordError = "Паролі не співпадають"
            hasError = true
        }

        guard !hasError else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let err = error as NSError?, let code = AuthErrorCode.Code(rawValue: err.code) {
                    switch code {
                    case .emailAlreadyInUse:
                        self?.emailError = "Ця пошта вже зареєстрована"
                    case .weakPassword:
                        self?.passwordError = "Пароль занадто простий"
                    default:
                        self?.emailError = "Помилка: \(err.localizedDescription)"
                    }
                } else {
                    // Успішна реєстрація
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.displayName = username
                        changeRequest.commitChanges { _ in }
                    }
                    self?.isLoggedIn = true
                }
            }
        }
    }

    // Вихід з акаунта
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Помилка виходу: \(error.localizedDescription)")
        }
    }

    // Очистити помилки
    func clearErrors() {
        emailError = ""
        passwordError = ""
        usernameError = ""
        confirmPasswordError = ""
    }
}
