//
//  TodoCellViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class TodoCellViewModel {
    let spacing: CGFloat = 16
    let contentOffset: CGFloat = 20
    
    let todoTitleLabelFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    let todoTitleLabelColor: UIColor = .label
    let todoTitleNumberOfLines = 0
    
    let alarmLabelFont: UIFont = .systemFont(ofSize: 17, weight: .medium)
    let alarmLabelColor: UIColor = .darkGray
    let alarmLabelNumberOfLines = 1
    
    let stackViewSpacing: CGFloat = 8
}
