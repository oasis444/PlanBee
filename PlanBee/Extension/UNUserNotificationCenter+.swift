//
//  UNUserNotificationCenter+.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "알림❗️"
        content.subtitle = "테스트 알림입니다."
        content.body = "테스트 알림을 위해 발송된 푸시 알림 입니다."
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        let request = UNNotificationRequest(identifier: alert.id.uuidString, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
