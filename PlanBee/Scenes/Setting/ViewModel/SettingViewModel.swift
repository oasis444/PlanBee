//
//  SettingViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class SettingViewModel {
    let settingViewNavigationTitle = "설정"

    func subTitle(type: SettingSection.Setting) -> String? {
        if type == .screenMode {
            let rawValue = UserDefaults.standard.integer(forKey: "Appearance")
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
        if type == .alarm {
            return nil
        }
        return nil
    }
}
