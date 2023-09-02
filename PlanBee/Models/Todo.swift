//
//  Todo.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

enum Todokeys: String {
    case uuid
    case content
    case date
    case priority
    case done
    case alarm
    case serverid
    
    var key: String { rawValue }
}

struct Todo {
    var id: UUID = UUID()
    var content: String
    var date: String
    var priority = Date()
    var serverid: Int16?
    var done: Bool = false
    var alarm: Date?
}
