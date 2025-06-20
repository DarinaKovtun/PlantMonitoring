//
//  StatsView.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 19.06.2025.
//

import SwiftUI
import Charts

struct StatsView: View {
    let userId: String
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Вибір рослини
                Picker("Оберіть рослину", selection: $viewModel.selectedPlantId) {
                    ForEach(viewModel.plants, id: \.id) { plant in
                        Text(plant.name).tag(plant.id ?? "")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.selectedPlantId) { _ in
                    viewModel.fetchMoistureData(userId: userId)
                }

                // Вибір періоду
                Picker("Період", selection: $viewModel.selectedPeriod) {
                    ForEach(StatsPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: viewModel.selectedPeriod) { _ in
                    viewModel.fetchMoistureData(userId: userId)
                }

                // Графік вологості
                if viewModel.moistureRecords.isEmpty {
                    Text("Немає даних для відображення")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding()
                } else {
                    Chart(viewModel.moistureRecords) { record in
                        LineMark(
                            x: .value("Час", record.timestamp),
                            y: .value("Вологість", record.moisture)
                        )
                        .symbol(Circle())
                        .interpolationMethod(.catmullRom)
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 4))
                    }
                    .frame(height: 250)
                    .padding()
                }

                Spacer()
            }
            .navigationTitle("📊 Статистика")
            .onAppear {
                viewModel.fetchPlants(userId: userId)
            }
        }
    }
}
