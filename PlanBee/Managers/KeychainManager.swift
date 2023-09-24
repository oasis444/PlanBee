//
//  KeychainManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import SwiftKeychainWrapper

final class KeychainManager {
    enum KeychainKey: String {
        case token
    }
    
    /**
     # setKeychain
     - parameters:
        - value : 저장할 값(String)
        - keychainKey : 저장할 value의 Key - (E) Common.KeychainKey
     - Authors: z-wook
     - Note: 키체인에 값을 저장하는 공용 함수
     */
    static func setKeychain(_ value: String, forKey keychainKey: KeychainKey) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: keychainKey.rawValue)
    }

    /**
     # getKeychainValue
     - parameters:
        - keychainKey : 반환할 value의 Key(String?) - (E) Common.KeychainKey
     - Authors: z-wook
     - Note: 키체인 값을 반환하는 공용 함수
     */
    static func getKeychainStringValue(forKey keychainKey: KeychainKey) -> String? {
        let returnValue: String? = KeychainWrapper.standard.string(forKey: keychainKey.rawValue)
        return returnValue
    }
    
    /**
     # removeKeychain
     - parameters:
        - keychainKey : 삭제할 value의 Key - (E) Common.KeychainKey
     - Authors: z-wook
     - Note: 키체인 값을 삭제하는 공용 함수
     */
    static func removeKeychain(forKey keychainKey: KeychainKey) -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: keychainKey.rawValue)
    }
}
