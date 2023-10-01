//
//  LoginBtnType.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

enum LoginBtnType: String {
    case login = "로그인"
    case register = "회원가입"
    
    var title: String {
        return rawValue
    }
}
