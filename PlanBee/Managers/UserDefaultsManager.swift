//
//  UserDefaultsManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() { }
}

extension UserDefaultsManager {
    func setValue<T>(value: T, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getValue<T>(forKey key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
    /// 주의!!! UserDefaults에 저장된 모든 데이터 삭제
    func removeAllUserDefauls() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
            UserDefaults.standard.synchronize()
        }
    }
}
