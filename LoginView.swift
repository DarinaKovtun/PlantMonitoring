//
//  LoginView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 30.05.2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @Binding var showRegister: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Вхід")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)

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
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if !authVM.passwordError.isEmpty {
                    Text(authVM.passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            Button(action: {
                authVM.login(email: email, password: password)
            }) {
                Text("Увійти")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            Button(action: {
                authVM.clearErrors()
                showRegister = true
            }) {
                Text("Немає акаунта? Реєстрація")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .padding()
    }
}
