//
//  AlarmView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class AlarmView: UIView {
    lazy var removeAlarmBtn: UIButton = {
        let button = ButtonFactory.makeButton(
            title: "알림 삭제",
            titleLabelFont: ThemeFont.demibold(size: 22),
            titleColor: .systemPink)
        return button
    }()
    
    lazy var dismissBtn: UIButton = {
        let button = ButtonFactory.makeButton(type: .close)
        return button
    }()
    
    lazy var alarmDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    lazy var registerAlarmButton: UIButton = {
        let button = ButtonFactory.makeButton(
            title: "알림 설정",
            titleLabelFont: ThemeFont.bold(size: 30),
            titleColor: .white,
            backgroundColor: .systemPurple,
            cornerRadius: 15)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AlarmView {
    func setLayout() {
        [removeAlarmBtn, dismissBtn, alarmDatePicker, registerAlarmButton].forEach {
            self.addSubview($0)
        }
        
        removeAlarmBtn.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(AppConstraint.defaultSpacing)
            $0.centerY.equalTo(dismissBtn.snp.centerY)
        }
        
        dismissBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(AppConstraint.defaultSpacing)
            $0.width.equalTo(40)
            $0.height.equalTo(dismissBtn.snp.width)
        }
        
        alarmDatePicker.snp.makeConstraints {
            $0.top.equalTo(dismissBtn.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(AppConstraint.defaultSpacing)
        }
        
        registerAlarmButton.snp.makeConstraints {
            $0.top.equalTo(alarmDatePicker.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(AppConstraint.defaultSpacing)
        }
    }
}
