//
//  ReturnPlanBee.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class ReturnPlanBee {
    var saveTodoForReturnUser: Void {
        let calendar = Calendar.current
        let currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.month = -6
        
        if let startDate = calendar.date(byAdding: dateComponents, to: currentDate) {
            var currentDate = startDate
            
            while currentDate <= Date() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let formattedDate = dateFormatter.string(from: currentDate)
                Task {
                    if let todoList = await FirestoreManager.shared.getTodoList(strDate: formattedDate) {
                        if !todoList.isEmpty {
                            CoreDataManager.shared.saveTodoDataAtOnce(todos: todoList)
                        }
                    }
                }
                if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                    currentDate = nextDate
                } else {
                    break
                }
            }
        }
    }
}
