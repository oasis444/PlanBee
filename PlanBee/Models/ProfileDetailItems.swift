//
//  ProfileDetailItems.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

enum ProfileDetailItems: String, CaseIterable {
    case account = "계정"
    case service = "서비스"
    
    var title: String { rawValue }
    
    var items: [String] {
        switch self {
        case .account:
            return Account.allCases.map { $0.title }
        case .service:
            return Service.allCases.map { $0.title }
        }
    }
}

extension ProfileDetailItems {
    enum Account: String, CaseIterable {
        case password = "비밀번호 재설정"
        
        var title: String { rawValue }
    }
    
    enum Service: String, CaseIterable {
        case revoke = "서비스 탈퇴"
        
        var title: String { rawValue }
    }
}
