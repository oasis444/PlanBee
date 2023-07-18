//
//  ImageIcons.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

enum SettingIcons: CaseIterable {
    case setting
    case infomation
    case etc
    
    var iconImage: [UIImage] {
        switch self {
        case .setting:
            return Setting.allCases.map { UIImage(systemName: $0.imgName) ?? UIImage() }
        case .infomation:
            return Infomation.allCases.map { UIImage(systemName: $0.imgName) ?? UIImage() }
        case .etc:
            return Etc.allCases.map { UIImage(systemName: $0.imgName) ?? UIImage() }
        }
    }
    
    var iconColor: [UIColor] {
        switch self {
        case .setting:
            return Setting.allCases.map { $0.iconColor }
        case .infomation:
            return Infomation.allCases.map { $0.iconColor }
        case .etc:
            return Etc.allCases.map { $0.iconColor }
        }
    }
    
    enum Setting: String, CaseIterable {
        case screenMode = "lightbulb"
        case alarm = "exclamationmark.bubble"
        
        var imgName: String { rawValue }
        var iconColor: UIColor {
            switch self {
            case .screenMode:
                return .systemOrange
            case .alarm:
                return .systemPink
            }
        }
    }
    
    enum Infomation: String, CaseIterable {
        case version = "app.badge"
        case terms = "newspaper"
        case privacyTerms = "checkmark.shield"
        case openSource = "doc"
        case notice = "megaphone"
        case enquire = "text.bubble"
        
        var imgName: String { rawValue }
        var iconColor: UIColor {
            switch self {
            case .version:
                return .systemBlue
            case .terms:
                return UIColor(named: "darkTextColor_lightTextColor") ?? .label
            case .privacyTerms:
                return .systemBrown
            case .openSource:
                return .systemGreen
            case .notice:
                return .systemYellow
            case .enquire:
                return .link
            }
        }
    }
    
    enum Etc: String, CaseIterable {
        case developer = "person.2.circle.fill"
        case copyright = "square.and.pencil"
        case logout = "person.fill.xmark"
        
        var imgName: String { rawValue }
        var iconColor: UIColor {
            switch self {
            case .developer:
                return .label
            case .copyright:
                return UIColor(named: "darkTextColor_lightTextColor") ?? .label
            case .logout:
                return .label
            }
        }
    }
}
