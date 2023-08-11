//
//  SettingViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SettingViewModel {
    let settingViewNavigationTitle = "설정"
    private let appearanceKey = "Appearance"
    let userDefaultsManager = UserDefaultsManager.shared
    
    func subTitle(type: SettingSection.Setting) -> String? {
        if type == .screenMode {
            if let rawValue: Int = userDefaultsManager.getValue(forKey: appearanceKey) {
                var screenMode: String? {
                    switch rawValue {
                    case 0: return "시스템 기본값"
                    case 1: return "라이트 모드"
                    case 2: return "다크 모드"
                    default: return nil
                    }
                }
                return screenMode
            }
        }
        if type == .alarm {
            return nil
        }
        return nil
    }
    
    func saveScreenMode(viewController: UIViewController, mode: UserInterfaceStyle) {
        switch mode {
        case .unspecified:
            viewController.view.window?.overrideUserInterfaceStyle = .unspecified
            userDefaultsManager.setValue(value: 0, key: appearanceKey)
        case .light:
            viewController.view.window?.overrideUserInterfaceStyle = .light
            
            userDefaultsManager.setValue(value: 1, key: appearanceKey)
        case .dark:
            viewController.view.window?.overrideUserInterfaceStyle = .dark
            userDefaultsManager.setValue(value: 2, key: appearanceKey)
        }
    }
}
