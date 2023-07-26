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
                switch code {
                case 17007:
                    completion(.FIRAuthErrorCodeEmailAlreadyInUse)
                case 17008:
                    completion(.FIRAuthErrorCodeInvalidEmail)
                case 17009:
                    completion(.FIRAuthErrorCodeWrongPassword)
                case 17026:
                    completion(.FIRAuthErrorCodeLeastPasswordLength)
                default:
                    print("error: \(error.localizedDescription)")
                    completion(.unknown)
                    return
                }
            }
            guard let authResult = authResult else { return }
            let uid = authResult.user.uid
            // 앱 내 정보 저장하기
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
                case 17007:
                    completion(.FIRAuthErrorCodeEmailAlreadyInUse)
                case 17008:
                    completion(.FIRAuthErrorCodeInvalidEmail)
                case 17009:
                    completion(.FIRAuthErrorCodeWrongPassword)
                case 17026:
                    completion(.FIRAuthErrorCodeLeastPasswordLength)
                default:
                    print("error: \(error.localizedDescription)")
                    completion(.unknown)
                    return
                }
            }
            guard let authResult = authResult else { return }
            print("\(authResult.user.email), \(authResult.user.uid)")
            completion(nil)
        }
    }
    
    func checkLoginState() -> Bool {
        if auth.currentUser != nil {
            return false
        } else { return true }
    }
}
