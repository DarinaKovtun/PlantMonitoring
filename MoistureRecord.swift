//
//  MoistureRecord.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 19.06.2025.
//

import Foundation
import FirebaseFirestoreSwift

struct MoistureRecord: Identifiable, Codable {
    @DocumentID var id: String?
    var timestamp: Date
    var moisture: Int
}
