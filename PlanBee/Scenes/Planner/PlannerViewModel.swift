//
//  PlannerViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import Combine

final class PlannerViewModel {
    
    func saveTodo(saveTodo: Todo) -> Bool {
        let saveResult = CoreDataManager.saveTodoData(todo: saveTodo)
        if saveResult == false {
            // 에러 처리
            print("PlannerVM.saveTodo_Error")
        }
        return saveResult
    }
    
    func getDateList() -> [Date] {
        let todoList = CoreDataManager.fetchTodoData()
        guard let todoList = todoList else { return [] }
        let dateList = todoList.map { todo in
            todo.date
        }
        return dateList
    }
    
    func getTodoList(date: Date?) -> [Todo] {
        guard let date = date,
              let list = CoreDataManager.fetchTodoData() else { return [] }
        let selectedList = list.filter {
            $0.date == date
        }.sorted { prev, next in
            prev.priority < next.priority
        }
        return selectedList
    }
    
    func updateTodo(todo: Todo) -> Bool {
        return CoreDataManager.updatePlanData(newTodo: todo)
    }
    
    func removeTodo(todo: Todo) -> Bool {
        return CoreDataManager.deletePlanData(todo: todo)
    }
    
    func textFieldIsFullWithBlank(text: String) -> Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        print(trimmedText)
        return trimmedText.isEmpty ? true : false
    }
    
    func moveTodo(date: Date?, startIndex: Int, destinationIndex: Int) {
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
                done: $0.done
            )
            _ = updateTodo(todo: updatedTodo)
        }
    }
}
