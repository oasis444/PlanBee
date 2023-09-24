//
//  PlannerViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class PlannerViewModel {
    private let todoManager = TodoManager.shared
    var selectDate = Date()
}

extension PlannerViewModel {
    func numOfEvent(date: Date) -> Int {
        let strDate = DateFormatter.formatTodoDate(date: date)
        if getDateList.contains(strDate) {
            return 1
        }
        return 0
    }
    
    private var getDateList: [String] {
        return todoManager.getDateList()
    }
}
