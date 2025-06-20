//
//  PlantsViewModel.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class PlantsViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    private let db = Firestore.firestore()

    func fetchPlants(userId: String) {
        db.collection("users").document(userId).collection("plants")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching plants: \(error.localizedDescription)")
                    return
                }
                self.plants = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Plant.self)
                } ?? []
            }
    }

    func deletePlants(at offsets: IndexSet, userId: String) {
        offsets.forEach { index in
            if let plantId = plants[index].id {
                db.collection("users").document(userId).collection("plants").document(plantId).delete { error in
                    if let error = error {
                        print("Error deleting plant: \(error.localizedDescription)")
                    }
                }
            }
        }
        plants.remove(atOffsets: offsets)
    }

    func addPlant(name: String, type: PlantType, moisture: Int, light: Int, userId: String) {
        let newPlant = Plant(
            id: UUID().uuidString,
            name: name,
            type: type,
            moistureLevel: moisture,
            lightLevel: light
        )
        do {
            try db.collection("users")
                .document(userId)
                .collection("plants")
                .document(newPlant.id!)
                .setData(from: newPlant)
        } catch {
            print("Error adding plant: \(error.localizedDescription)")
        }
    }

    func updatePlant(_ plant: Plant, userId: String) {
        guard let plantId = plant.id else { return }
        do {
            try db.collection("users")
                .document(userId)
                .collection("plants")
                .document(plantId)
                .setData(from: plant)
        } catch {
            print("Error updating plant: \(error.localizedDescription)")
        }
    }
}
