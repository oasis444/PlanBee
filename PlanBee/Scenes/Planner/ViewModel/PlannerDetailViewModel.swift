//
//  PlannerDetailViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class PlannerDetailViewModel {
    private let todoManager = TodoManager.shared
    private var date: Date?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter
    }()
    
    init(selectedDate: Date?) {
        date = selectedDate
    }
}

extension PlannerDetailViewModel {
    var getDate: Date? {
        self.date
    }
    
    var dateLabelText: String {
        dateFormatter.string(from: date ?? Date())
    }
    
    func saveTodoResult(text: String) -> Bool {
        if todoManager.textIsFullWithBlank(text: text) == false {
            guard let date = getDate else { return false }
            let strDate = DateFormatter.formatTodoDate(date: date)
            let todo = Todo(
                content: text,
                date: strDate
            )
            return saveTodo(todo: todo)
        }
        return false
    }
}

private extension PlannerDetailViewModel {
    func saveTodo(todo: Todo) -> Bool {
        return todoManager.saveTodo(saveTodo: todo)
    }
}
