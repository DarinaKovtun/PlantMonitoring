//
//  FirebaseManager.swift
//  GreenMonitoring
//
//  Created by Darina Kovtun on 31.05.2025.
//

import Foundation
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    init() {
        FirebaseApp.configure()
    }
}
