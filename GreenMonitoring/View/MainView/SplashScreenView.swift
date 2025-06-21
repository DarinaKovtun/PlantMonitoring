//
//  SplashScreenView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 60) {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)

                Text("Plant Monitor")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Button(action: {
                    isActive = false
                }) {
                    Text("Почати")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
    }
}
