//
//  AlarmViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import UserNotifications

final class AlarmViewController: UIViewController {
    
    var todo: Todo?
    let viewModel = AlarmViewModel()
    var reloadTodoTableView: ((_ reloadTableView: Bool) -> Void)?
    
    private lazy var alarmDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private lazy var setAlarmButton: UIButton = {
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
    func configureView() {
        view.backgroundColor = .PlanBeeBackgroundColor
        navigationItem.title = viewModel.alarmViewNavigationTitle
    }
    
    func configureLayout() {
        [alarmDatePicker, setAlarmButton].forEach {
            view.addSubview($0)
        }
        
        alarmDatePicker.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(viewModel.contentViewSpacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.contentViewSpacing)
        }
        
        setAlarmButton.snp.makeConstraints {
            $0.top.equalTo(alarmDatePicker.snp.bottom).offset(viewModel.contentViewHeightSpacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.contentViewSpacing)
        }
    }
    
    @objc func didTappedSetAlarmBtn() {
        guard var todo = todo else { return }
        
        if checkAlarmDate() {
            todo.alarm = alarmDatePicker.date
            let updateResult = TodoManager().updateTodo(todo: todo)
            if updateResult {
                viewModel.addNotificationRequest(todo: todo)
            }
            dismiss(animated: true) {
                self.reloadTodoTableView?(true)
            }
        } else {
            showAlert()
        }
    }
    
    func checkAlarmDate() -> Bool {
        if alarmDatePicker.date > Date() {
            return true
        } else {
            return false
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "알림 설정 오류", message: "현재 시간보다 이전으로 알림을 설정할 수 없습니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
