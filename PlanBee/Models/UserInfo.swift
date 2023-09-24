//
//  UserInfo.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

struct UserInfo {
    let id: String // 사용자의 고유한 아이디 -> 서버에서 생성
    let username: String
    let password: String
    let email: String
    let url: String?
}
