//
//  RegisterView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    
    @Binding var showRegister: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Реєстрація")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)

            VStack(alignment: .leading, spacing: 5) {
                TextField("Ім'я користувача", text: $username)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if !authVM.usernameError.isEmpty {
                    Text(authVM.usernameError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if !authVM.emailError.isEmpty {
                    Text(authVM.emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                SecureField("Пароль", text: $password)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if !authVM.passwordError.isEmpty {
                    Text(authVM.passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                SecureField("Підтвердьте пароль", text: $confirmPassword)
                    .textContentType(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if !authVM.confirmPasswordError.isEmpty {
                    Text(authVM.confirmPasswordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            Button(action: {
                authVM.register(email: email, password: password, confirmPassword: confirmPassword, username: username)
            }) {
                Text("Зареєструватись")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            Button(action: {
                authVM.clearErrors()
                showRegister = false
            }) {
                Text("Вже є акаунт? Увійти")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .padding()
    }
}
