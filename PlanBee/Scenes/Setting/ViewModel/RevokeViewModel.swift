//
//  RevokeViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class RevokeViewModel {
    private let firebaseManager = FirebaseManager.shared
    
    /// 주의!!! 모든 정보 삭제하기
    func removeAllInfo(completion: @escaping () -> Void) {
        UserDefaultsManager.shared.removeAllUserDefauls()
        CoreDataManager.shared.removeAllPlanData()
        Task {
            await FirestoreManager.shared.saveRevokeUser()
            if await FirebaseManager.shared.removeUser() {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    /// 재인증
    func reAuthenticate(password: String, completion: @escaping (Bool) -> Void) {
        Task {
            if await firebaseManager.reAuthenticate(password: password) {
                DispatchQueue.main.async {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
}
