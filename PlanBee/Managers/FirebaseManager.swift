//
//  FirebaseManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import FirebaseAuth

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() { }
    
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
    
    func sendEmailForChangePW() async -> Bool {
        guard let email = auth.currentUser?.email else { return false }
        do {
            try await auth.sendPasswordReset(withEmail: email)
            return true
        } catch {
            print("error: \(error.localizedDescription)")
            return false
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
            print("error: \(error.localizedDescription)")
            return error.localizedDescription
        }
    }
    
    var getUserEmail: String {
        guard let currentUserEmail = auth.currentUser?.email else { return "익명" }
        return currentUserEmail
    }
    
    func getUID() -> String? {
        return auth.currentUser?.uid
    }
}

extension FirebaseManager {
    // 재인증
    func reAuthenticate(password: String) async -> Bool {
        guard let user = auth.currentUser else { return false }
        let credential = EmailAuthProvider.credential(withEmail: getUserEmail, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
            return true
        } catch {
            print("error: \(error.localizedDescription)")
            return false
        }
    }
    
    func removeUser() async -> Bool {
        guard let user = auth.currentUser else { return false }
        do {
            try await user.delete()
            return true
        } catch {
            print("error: \(error.localizedDescription)")
            return false
        }
    }
}
