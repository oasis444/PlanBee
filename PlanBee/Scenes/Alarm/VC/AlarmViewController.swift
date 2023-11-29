//
//  AlarmViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class AlarmViewController: UIViewController {
    private let alarmView = AlarmView()
    private let viewModel = AlarmViewModel()
    private var todo: Todo?
    var reloadTodoTableView: ((_ reloadTableView: Bool) -> Void)?
    
    override func loadView() {
        super.loadView()
        
        view = alarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setButtonTarget()
    }
    
    deinit {
        print("deinit - AlarmVC")
    }    
}

extension AlarmViewController {
    func configure(todo: Todo) {
        self.todo = todo
    }
}

private extension AlarmViewController {
    func configure() {
        view.backgroundColor = ThemeColor.PlanBeeBackgroundColor
    }
    
    func setButtonTarget() {
        alarmView.removeAlarmBtn.addTarget(
            self,
            action: #selector(didTappedRemoveAlarmBtn),
            for: .touchUpInside)
        alarmView.dismissBtn.addTarget(
            self,
            action: #selector(didTappedDismissBtn),
            for: .touchUpInside)
        alarmView.registerAlarmButton.addTarget(
            self,
            action: #selector(didTappedSetAlarmBtn),
            for: .touchUpInside)
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

private extension AlarmViewController {
    @objc func didTappedRemoveAlarmBtn() {
        guard var todo = todo,
              todo.alarm != nil else { return }
        todo.alarm = nil
        
        viewModel.removeAlarm(todo: todo) { [weak self] result in
            guard let self = self else { return }
            if result {
                dismiss(animated: true) {
                    self.reloadTodoTableView?(true)
                    return
                }
            }
            showAlert(title: "알림 삭제 오류", message: "알림 삭제에 실패했습니다. 잠시 후 다시 시도해 주세요.")
        }
    }
    
    @objc func didTappedSetAlarmBtn() {
        guard var todo = todo else { return }
        let check = viewModel.checkAlarmDate(date: alarmView.alarmDatePicker.date)
        if check {
            todo.alarm = alarmView.alarmDatePicker.date
            viewModel.setAlarm(todo: todo) { [weak self] result in
                guard let self = self else { return }
                if result {
                    dismiss(animated: true) {
                        self.reloadTodoTableView?(true)
                        return
                    }
                }
                showAlert(title: "알림 삭제 오류", message: "알림 삭제에 실패했습니다. 잠시 후 다시 시도해 주세요.")
            }
        }
    }
    
    @objc func didTappedDismissBtn() {
        dismiss(animated: true)
    }
}
