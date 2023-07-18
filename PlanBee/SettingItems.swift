//
//  SettingItems.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

enum SettingSection: String, CaseIterable {
    case setting = "앱 설정"
    case infomation = "이용 안내"
    case etc = "기타"
    
    var title: String { rawValue }
    
    var items: [String] {
        switch self {
        case .setting:
            return Setting.allCases.map { $0.title }
        case .infomation:
            return Infomation.allCases.map { $0.title }
        case .etc:
            return Etc.allCases.map { $0.title }
        }
    }
}

private extension SettingSection {
    enum Setting: String, CaseIterable {
        case screenMode = "화면 모드"
        case alarm = "알림 설정"
        
        var title: String { rawValue }
    }
    
    enum Infomation: String, CaseIterable {
        case version = "버전 정보"
        case terms = "이용약관"
        case privacyTerms = "개인정보 처리 방침"
        case openSource = "오픈소스 라이선스"
        case notice = "공지사항"
        case enquire = "문의하기"
        
        var title: String { rawValue }
    }
    
    enum Etc: String, CaseIterable {
        case developer = "개발진"
        case copyright = "저작권"
        case logout = "로그아웃"
        
        var title: String { rawValue }
    }
}
