//
//  PlanTodo.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

/// 서버 Schema
struct MyTodo: Codable {
    let id: Int
    let content: String
    let done: Int
    let createdAt: String
}
