//
//  FirebaseManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import FirebaseAuth

class FirebaseManager {
    private let auth = Auth.auth()
    
    func createUsers(email: String, password: String, completion: @escaping (FirebaseErrors?) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let sampleError = (error as NSError)
                let code = sampleError.code
                print("code: \(code)")
                switch code {
                case 17005:
                    completion(.FIRAuthErrorCodeUserDisabled)
                case 17007:
                    completion(.FIRAuthErrorCodeEmailAlreadyInUse)
                case 17008:
                    completion(.FIRAuthErrorCodeInvalidEmail)
                case 17009:
                    completion(.FIRAuthErrorCodeWrongPassword)
                case 17011:
                    completion(.FIRAuthErrorCodeOperationNotAllowed)
                case 17026:
                    completion(.FIRAuthErrorCodeLeastPasswordLength)
                default:
                    print("error: \(error.localizedDescription)")
                    completion(.unknown)
                    return
                }
            }
            guard authResult != nil else { return }
            completion(nil)
        }
    }
    
    func emailLogIn(email: String, password: String, completion: @escaping (FirebaseErrors?) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let sampleError = (error as NSError)
                let code = sampleError.code
                print("에러코드: \(code)")
                switch code {
                case 17005:
                    completion(.FIRAuthErrorCodeUserDisabled)
                case 17007:
                    completion(.FIRAuthErrorCodeEmailAlreadyInUse)
                case 17008:
                    completion(.FIRAuthErrorCodeInvalidEmail)
                case 17009:
                    completion(.FIRAuthErrorCodeWrongPassword)
                case 17011:
                    completion(.FIRAuthErrorCodeOperationNotAllowed)
                case 17026:
                    completion(.FIRAuthErrorCodeLeastPasswordLength)
                default:
                    print("error: \(error.localizedDescription)")
                    completion(.unknown)
                    return
                }
            }
            guard authResult != nil else { return }
            completion(nil)
        }
    }
    
    func checkLoginState() -> Bool {
        if auth.currentUser != nil {
            return true
        } else { return false }
    }
    
    func logOut() -> String? {
        do {
            try auth.signOut()
            return nil
        } catch {
            return error.localizedDescription
        }
    }
    
    func getUserEmail() -> String {
        guard let currentUserEmail = auth.currentUser?.email else { return "익명" }
        print(currentUserEmail)
        return currentUserEmail
    }
}
