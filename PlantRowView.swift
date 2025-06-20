//
//  PlantRowView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import SwiftUI

struct PlantRowView: View {
    let plant: Plant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 15) {
                Image(systemName: plant.type == .rose ? "rose.fill" : "tulip.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(plant.type == .rose ? .red : .pink)

                VStack(alignment: .leading, spacing: 5) {
                    Text(plant.name)
                        .font(.headline)
                    Text(plant.type.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 10) {
                        Label("\(plant.moistureLevel)%", systemImage: "drop.fill")
                            .foregroundColor(plant.needsWater ? .blue : .gray)
                        Label("\(plant.lightLevel)%", systemImage: "sun.max.fill")
                            .foregroundColor(plant.needsLight ? .yellow : .gray)
                    }
                    .font(.caption)
                }

                Spacer()
            }

            // 🔔 Рекомендації
            if plant.needsWater || plant.needsLight {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Рекомендації:")
                        .font(.subheadline)
                        .fontWeight(.bold)

                    if plant.needsWater {
                        Label("Рекомендується полив 🌧️", systemImage: "exclamationmark.circle.fill")
                            .foregroundColor(.blue)
                    }

                    if plant.needsLight {
                        Label("Поставити ближче до світла ☀️", systemImage: "lightbulb.fill")
                            .foregroundColor(.orange)
                    }
                }
                .padding(8)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding(.vertical, 8)
    }
}
