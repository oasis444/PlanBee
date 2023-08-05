//
//  TodoManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class TodoManager {
    private let storeManager = FirestoreManager()
    
    func saveTodo(saveTodo: Todo) async -> Bool {
        let result = Task {
            if await storeManager.saveTodo(data: saveTodo) == true {
                if CoreDataManager.saveTodoData(todo: saveTodo) { return true }
            }
            return false
        }
        return await result.value
    }
    
    func getDateList() -> [String] {
        let todoList = CoreDataManager.fetchTodoData()
        guard let todoList = todoList else { return [] }
        let dateList = todoList.map { todo in
            todo.date
        }
        return dateList
    }
    
    func getTodoList(date: Date?) -> [Todo] {
        guard let date = date,
              let list = CoreDataManager.fetchTodoData(date: date) else { return [] }
        let sortedList = list.sorted {
            $0.priority < $1.priority
        }
        return sortedList
    }
    
    func updateTodo(todo: Todo) async -> Bool {
        let result = Task {
            if await storeManager.updateTodo(data: todo) == true {
                if CoreDataManager.updatePlanData(newTodo: todo) { return true }
            }
            return false
        }
        return await result.value
    }
    
    func removeTodo(todo: Todo) async -> Bool {
        let result = Task {
            if await storeManager.deleteTodo(data: todo) == true {
                if CoreDataManager.deletePlanData(todo: todo) { return true }
            }
            return false
        }
        return await result.value
    }
    
    func textFieldIsFullWithBlank(text: String) -> Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        return trimmedText.isEmpty ? true : false
    }
    
    func moveTodo(date: Date?, startIndex: Int, destinationIndex: Int) async {
        var todoList = getTodoList(date: date)
        todoList.swapAt(startIndex, destinationIndex)
        let newIndex = destinationIndex + 1
        
        todoList[newIndex...].sort {
            $0.priority < $1.priority
        }
            todoList[destinationIndex...].forEach {
                let updatedTodo = Todo(
                    id: $0.id,
                    content: $0.content,
                    date: $0.date,
                    priority: Date(),
                    done: $0.done,
                    alarm: $0.alarm
                )
                Task {
                    await updateTodo(todo: updatedTodo)
                }
//            if storeManager.updateTodo(data: updatedTodo) != nil { return }
//            _ = updateTodo(todo: updatedTodo)
        }
    }
}
