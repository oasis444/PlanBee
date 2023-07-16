//
//  UserNotificationManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import UserNotifications

final class UserNotificationManager {
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func addAlarm(todo: Todo) {
        guard let alarmDate = todo.alarm else { return }
        let alert = Alert(id: todo.id, date: alarmDate)
        userNotificationCenter.addNotificationRequest(alert: alert)
    }
    
    func removeAlarm(todo: Todo, completion: ((Bool) -> Void)?) { // 사용자가 직접 삭제하는 경우
        let newTodo = Todo(id: todo.id,
                           content: todo.content,
                           date: todo.date,
                           priority: todo.priority,
                           done: todo.done,
                           alarm: nil)
        
        if TodoManager().updateTodo(todo: newTodo) {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [todo.id.uuidString])
            userNotificationCenter.removeDeliveredNotifications(withIdentifiers: [todo.id.uuidString])
            completion?(true)
        } else {
            completion?(false)
        }
    }
    
    func removeAllDeliveredAlarm() {
        userNotificationCenter.removeAllDeliveredNotifications()
    }
}
