//
//  AlarmViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import UserNotifications

final class AlarmViewModel {
    private let todoManager = TodoManager.shared
    private let notificationManager = UserNotificationManager.shared
}

extension AlarmViewModel {
    func checkAlarmDate(date: Date) -> Bool {
        if date > Date() {
            return true
        } else {
            return false
        }
    }
    
    func removeAlarm(todo: Todo, completion: @escaping (Bool) -> Void) {
        Task {
            if await todoManager.updateTodo(todo: todo) {
                removeAlarm(todo: todo)
                DispatchQueue.main.async {
                    completion(true)
                    return
                }
            }
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
    
    func setAlarm(todo: Todo, completion: @escaping (Bool) -> Void) {
        Task {
            if await todoManager.updateTodo(todo: todo) {
                addAlarm(todo: todo)
                DispatchQueue.main.async {
                    completion(true)
                    return
                }
            }
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
    
    private func removeAlarm(todo: Todo) {
        notificationManager.removeAlarm(todo: todo)
    }
    
    private func addAlarm(todo: Todo) {
        notificationManager.addAlarm(todo: todo)
    }
}
