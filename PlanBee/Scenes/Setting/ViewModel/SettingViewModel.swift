//
//  SettingViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

enum UserInterfaceStyle: Int {
    case unspecified = 0
    case light = 1
    case dark = 2
}

final class SettingViewModel {
    private let firebaseManager = FirebaseManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    let appearanceKey = "Appearance"
}

extension SettingViewModel {
    func logout() -> Bool {
        if firebaseManager.logOut() != nil {
            return false
        }
        return true
    }
    
    func subTitle(type: SettingSection.Setting) -> String? {
        switch type {
        case .screenMode:
            guard let rawValue: Int = userDefaultsManager.getValue(forKey: appearanceKey) else { return nil }
            var screenMode: String? {
                switch rawValue {
                case 0: return "시스템 기본값"
                case 1: return "라이트 모드"
                case 2: return "다크 모드"
                default: return nil
                }
            }
            return screenMode
            
        case .alarm:
            return nil
        }
    }
    
    func saveScreenMode(mode: UserInterfaceStyle) {
        switch mode {
        case .unspecified:
            userDefaultsManager.setValue(value: 0, key: appearanceKey)
        case .light:
            userDefaultsManager.setValue(value: 1, key: appearanceKey)
        case .dark:
            userDefaultsManager.setValue(value: 2, key: appearanceKey)
        }
    }
}
