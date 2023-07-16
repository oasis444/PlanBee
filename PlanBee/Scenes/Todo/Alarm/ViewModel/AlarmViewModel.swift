//
//  AlarmViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import UserNotifications

final class AlarmViewModel {
    let alarmBtnTitle = "알림 설정"
    
    let removeAlarmBtnTitle = "알림 삭제"
    let removeAlarmBtnFont: UIFont = .systemFont(ofSize: 22, weight: .medium)
    let removeAlarmBtnColor: UIColor = .systemPink
    
    let contentViewSpacing: CGFloat = 16
    let contentViewHeightSpacing: CGFloat = 50
    
    let alarmBtnTintColor: UIColor = .white
    let alarmBtnBackgroundColor: UIColor = .systemPurple
    let alarmBtnFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    let alarmBtnCornerRadius: CGFloat = 15
    
    let dismissBtnWidth: CGFloat = 40
    
    let removeAlertTitle = "알림 삭제 오류"
    let removeAlertMessage = "알림 삭제에 실패했습니다. 잠시 후 다시 시도해 주세요."
    let setAlertTitle = "알림 설정 오류"
    let setAlertMessage = "현재 시간보다 이전으로 알림을 설정할 수 없습니다."
}
