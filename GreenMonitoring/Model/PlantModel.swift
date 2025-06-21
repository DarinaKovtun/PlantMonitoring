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
    @DocumentID var id: String?
    var name: String
    var type: PlantType
    var moistureLevel: Int
    var lightLevel: Int

    // 🔧 нові порогові значення
    var moistureThreshold: Int
    var lightThreshold: Int

    var needsWater: Bool {
        moistureLevel < moistureThreshold
    }

    var needsLight: Bool {
        lightLevel < lightThreshold
    }
}
