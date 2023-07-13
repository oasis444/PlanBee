//
//  TodoViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class TodoViewModel {
    
    let todoTitle = "오늘 일정"
    let navigationRightBtnTitle = "편집"
    let formatter = DateFormatter()
    
    var todoHeaderTitle: String {
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }
    
    let alarmActionTitle = "알림 설정"
    
    var alarmActionImage: UIImage {
        UIImage(systemName: "alarm") ?? UIImage()
    }
}
