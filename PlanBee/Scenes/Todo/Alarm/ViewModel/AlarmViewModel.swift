//
//  AlarmViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import UserNotifications

final class AlarmViewModel {
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    let alarmViewNavigationTitle = "알람 설정"
    let alarmBtnTitle = "알람 설정"

    let contentViewSpacing: CGFloat = 16
    let contentViewHeightSpacing: CGFloat = 50
    
    let alarmBtnTintColor: UIColor = .white
    let alarmBtnBackgroundColor: UIColor = .systemPurple
    let alarmBtnFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    let alarmBtnCornerRadius: CGFloat = 15
    
    func addNotificationRequest(todo: Todo) {
        guard let alarmDate = todo.alarm else { return }
        let alert = Alert(id: todo.id, date: alarmDate)
        userNotificationCenter.addNotificationRequest(alert: alert)
    }
}
