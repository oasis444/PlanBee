//
//  UNUserNotificationCenter+.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(todo: Todo, alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "알림❗️"
        content.body = todo.content
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: alert.id.uuidString, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
