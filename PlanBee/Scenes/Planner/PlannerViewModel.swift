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
    
    func getSelectedTodoList(date: Date?) -> [Todo] {
        guard let date = date,
              let list = CoreDataManager.fetchTodoData() else { return [] }
        let selectedList = list.filter {
            $0.date == date
        }
        return selectedList
    }
}
