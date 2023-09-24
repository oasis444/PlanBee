//
//  TodoViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class TodoViewModel {
    private let todoManager = TodoManager.shared
    private let formatter = DateFormatter()
}

extension TodoViewModel {
    var todoHeaderTitle: String {
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }
    
    var getTodoList: [Todo] {
        return todoManager.getTodoList(date: Date())
    }
    
    func updateTodo(index: Int) async -> Bool {
        var selectedTodo = getTodoList[index]
        selectedTodo.done.toggle()
        let result = await todoManager.updateTodo(todo: selectedTodo)
        return result
    }
    
    func moveTodo(startIndex: Int, destinationIndex: Int) {
        Task {
            await todoManager.moveTodo(date: Date(), startIndex: startIndex, destinationIndex: destinationIndex)
        }
    }
    
    func removeTodo(index: Int) async -> Bool {
        let todo = getTodoList[index]
        return await todoManager.removeTodo(todo: todo)
    }
}
