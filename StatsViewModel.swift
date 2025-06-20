//
//  StatsViewModel.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 19.06.2025.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class StatsViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var selectedPlantId: String = ""
    @Published var selectedPeriod: StatsPeriod = .week
    @Published var moistureRecords: [MoistureRecord] = []

    private let db = Firestore.firestore()

    func fetchPlants(userId: String) {
        db.collection("users")
            .document(userId)
            .collection("plants")
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    self.plants = documents.compactMap { try? $0.data(as: Plant.self) }
                    if let firstId = self.plants.first?.id {
                        self.selectedPlantId = firstId
                        self.fetchMoistureData(userId: userId)
                    }
                }
            }
    }

    func fetchMoistureData(userId: String) {
        guard !selectedPlantId.isEmpty else { return }

        let calendar = Calendar.current
        let now = Date()
        let fromDate: Date

        switch selectedPeriod {
        case .day:
            fromDate = calendar.startOfDay(for: now)
        case .week:
            fromDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .month:
            fromDate = calendar.date(byAdding: .month, value: -1, to: now)!
        }

        db.collection("users")
            .document(userId)
            .collection("plants")
            .document(selectedPlantId)
            .collection("moistureData")
            .whereField("timestamp", isGreaterThanOrEqualTo: fromDate)
            .order(by: "timestamp")
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    self.moistureRecords = documents.compactMap { doc in
                        let data = doc.data()
                        guard let ts = data["timestamp"] as? Timestamp,
                              let moisture = data["moisture"] as? Int else { return nil }
                        return MoistureRecord(timestamp: ts.dateValue(), moisture: moisture)
                    }
                } else {
                    self.moistureRecords = []
                }
            }
    }

    /// ➕ Додати тестовий запис вологості для перевірки графіка
    func addTestMoistureRecord(userId: String) {
        guard !selectedPlantId.isEmpty else { return }

        let testData: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "moisture": Int.random(in: 20...80)
        ]

        db.collection("users")
            .document(userId)
            .collection("plants")
            .document(selectedPlantId)
            .collection("moistureData")
            .addDocument(data: testData) { error in
                if let error = error {
                    print("❌ Error adding test data: \(error.localizedDescription)")
                } else {
                    print("✅ Test moisture data added")
                    self.fetchMoistureData(userId: userId)
                }
            }
    }
}

enum StatsPeriod: String, CaseIterable {
    case day = "Сьогодні"
    case week = "Тиждень"
    case month = "Місяць"
}

