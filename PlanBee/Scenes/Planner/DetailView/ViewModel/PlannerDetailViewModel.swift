//
//  PlannerDetailViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class PlannerDetailViewModel {
    private var date: Date?
    
    let layoutSpacing: CGFloat = 16
    let layoutContentSpacing: CGFloat = 40
    let tableViewCornerRadius: CGFloat = 15
    
    let dateLabelFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    
    var getDate: Date? {
        self.date
    }
    
    init(selectedDate: Date?) {
        date = selectedDate
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter
    }()
    
    var dateLabelText: String {
        dateFormatter.string(from: date ?? Date())
    }
    
    let dateLabelTextColor: UIColor = .label
    
    var addTodoBtnImage: UIImage {
        UIImage(systemName: "plus.circle") ?? UIImage()
    }
    
    let textFieldPlaceHolderText = "할 일을 추가해주세요"
    let textFieldBackgoundColor: UIColor = .systemBackground
    let textFieldFont: UIFont = .systemFont(ofSize: 20)
    let textFieldBorderStyle: UITextField.BorderStyle = .roundedRect
    
    let editBtnTitle = "편집"
    let editBtnTitleColor: UIColor = .systemBlue
    
    let alertTitle = "Todo 저장 실패"
    let alertMessage = "잠시 후 다시 시도해 주세요."
    let alertActionTitle = "확인"
    
    let tableViewHeaderTitle = "Todo"
}
