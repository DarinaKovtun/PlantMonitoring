//
//  PlantService.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PlantService: ObservableObject {
    private let db = Firestore.firestore()
    @Published var plants: [Plant] = []

    let userId: String  // для фильтрації рослин за користувачем

    init(userId: String) {
        self.userId = userId
        fetchPlants()
    }

    func fetchPlants() {
        db.collection("users")
            .document(userId)
            .collection("plants")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents or error: \(error?.localizedDescription ?? "unknown error")")
                    return
                }
                self?.plants = documents.compactMap { doc -> Plant? in
                    try? doc.data(as: Plant.self)
                }
            }
    }

    func addPlant(_ plant: Plant) {
        do {
            let _ = try db.collection("users")
                .document(userId)
                .collection("plants")
                .addDocument(from: plant)
        } catch {
            print("Error adding plant: \(error.localizedDescription)")
        }
    }
}

