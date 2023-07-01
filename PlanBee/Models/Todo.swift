//
//  Todo.swift
//  PlanBee
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation

enum Todokeys: String {
    case uuid
    case content
    case date
    case done
    
    var key: String {
        switch self {
        case .uuid, .content, .date, .done: return self.rawValue
        }
    }
}

struct Todo {
    var id: UUID = UUID()
    var content: String
    var date: Date = Date.now
    var done: Bool = false
}
