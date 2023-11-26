//
//  UserNotificationManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import UserNotifications

final class UserNotificationManager {
    static let shared = UserNotificationManager()
    private init() { }
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
}

extension UserNotificationManager {
    func addAlarm(todo: Todo) {
        guard let alarmDate = todo.alarm else { return }
        let alert = Alert(id: todo.id, date: alarmDate)
        userNotificationCenter.addNotificationRequest(todo: todo, alert: alert)
    }
    
    func removeAlarm(todo: Todo) { // 사용자가 직접 삭제하는 경우
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [todo.id.uuidString])
        userNotificationCenter.removeDeliveredNotifications(withIdentifiers: [todo.id.uuidString])
    }
    
    func removeAllDeliveredAlarm() {
        userNotificationCenter.removeAllDeliveredNotifications()
    }
}
