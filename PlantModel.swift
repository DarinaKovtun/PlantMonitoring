//
//  PlantModel.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 02.06.2025.
//

import Foundation
import FirebaseFirestoreSwift

enum PlantType: String, CaseIterable, Identifiable, Codable {
    case rose = "Роза"
    case tulip = "Тюльпан"

    var id: String { rawValue }
}

struct Plant: Identifiable, Codable {
    @DocumentID var id: String?  // id документа из Firestore
    let name: String
    let type: PlantType
    var moistureLevel: Int
    var lightLevel: Int

    var needsWater: Bool {
        moistureLevel < 30
    }
    var needsLight: Bool {
        lightLevel < 40
    }
}
