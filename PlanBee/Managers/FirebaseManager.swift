//
//  FirebaseManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import FirebaseAuth

class FirebaseManager {
    let auth = Auth.auth()
    
    func checkLoginState() -> Bool {
        if auth.currentUser != nil {
            return false
        } else { return true }
    }
}
