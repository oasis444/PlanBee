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
    
    var key: String {
        switch self {
        case .uuid, .content, .date, .priority, .done: return self.rawValue
        }
    }
}

struct Todo {
    var id: UUID = UUID()
    var content: String
    var date: Date
    var priority = Date()
    var done: Bool = false
}
