//
//  AlarmViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class AlarmViewController: UIViewController {
    
    var todo: Todo?
    private let viewModel = AlarmViewModel()
    private let alarmManager = UserNotificationManager()
    var reloadTodoTableView: ((_ reloadTableView: Bool) -> Void)?
    
    private lazy var removeAlarmBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.removeAlarmBtnTitle, for: .normal)
        button.titleLabel?.font = viewModel.removeAlarmBtnFont
        button.setTitleColor(viewModel.removeAlarmBtnColor, for: .normal)
        button.addTarget(self, action: #selector(didTappedRemoveAlarmBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var dismissBtn: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(didTappedDismissBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarmDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private lazy var registerAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.alarmBtnTitle, for: .normal)
        button.titleLabel?.font = viewModel.alarmBtnFont
        button.tintColor = viewModel.alarmBtnTintColor
        button.backgroundColor = viewModel.alarmBtnBackgroundColor
        button.layer.cornerRadius = viewModel.alarmBtnCornerRadius
        button.addTarget(self, action: #selector(didTappedSetAlarmBtn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
    }
    
    deinit {
        print("deinit - AlarmVC")
    }
}

private extension AlarmViewController {
    @objc func didTappedRemoveAlarmBtn() {
        guard var todo = todo,
              todo.alarm != nil else { return }
        todo.alarm = nil
        alarmManager.removeAlarm(todo: todo) { [weak self] result in
            guard let self = self else { return }
            if result {
                self.reloadTodoTableView?(result)
                dismiss(animated: true)
            } else {
                showAlert(title: viewModel.removeAlertTitle, message: viewModel.removeAlertMessage)
            }
        }
    }
    
    @objc func didTappedDismissBtn() {
        dismiss(animated: true)
    }
    
    @objc func didTappedSetAlarmBtn() {
        guard var todo = todo else { return }
        if checkAlarmDate() {
            todo.alarm = alarmDatePicker.date
            let updateResult = TodoManager().updateTodo(todo: todo)
            if updateResult {
                alarmManager.addAlarm(todo: todo)
            }
            dismiss(animated: true) {
                self.reloadTodoTableView?(true)
            }
        } else {
            showAlert(title: viewModel.setAlertTitle, message: viewModel.setAlertMessage)
        }
    }
}

private extension AlarmViewController {
    func configureView() {
        view.backgroundColor = .PlanBeeBackgroundColor
    }
    
    func configureLayout() {
        [removeAlarmBtn, dismissBtn, alarmDatePicker, registerAlarmButton].forEach {
            view.addSubview($0)
        }
        
        removeAlarmBtn.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(viewModel.contentViewSpacing)
            $0.centerY.equalTo(dismissBtn.snp.centerY)
        }
        
        dismissBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.contentViewSpacing)
            $0.width.equalTo(viewModel.dismissBtnWidth)
            $0.height.equalTo(dismissBtn.snp.width)
        }
        
        alarmDatePicker.snp.makeConstraints {
            $0.top.equalTo(dismissBtn.snp.bottom).offset(viewModel.contentViewHeightSpacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.contentViewSpacing)
        }
        
        registerAlarmButton.snp.makeConstraints {
            $0.top.equalTo(alarmDatePicker.snp.bottom).offset(viewModel.contentViewHeightSpacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.contentViewSpacing)
        }
    }
    
    func checkAlarmDate() -> Bool {
        if alarmDatePicker.date > Date() {
            return true
        } else {
            return false
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
