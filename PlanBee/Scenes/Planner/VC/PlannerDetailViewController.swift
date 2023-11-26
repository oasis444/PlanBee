//
//  PlannerDetailViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Combine
import SwiftUI
import UIKit

final class PlannerDetailViewController: UIViewController {
    private var plannerDetailView = PlannerDetailView()
    private var viewModel: PlannerDetailViewModel?
    var reloadCalendar: ((_ relodaCalendar: Bool) -> Void)?
    private var subscriptions = Set<AnyCancellable>()
    
    init(date: Date) {
        super.init(nibName: nil, bundle: nil)
        viewModel = PlannerDetailViewModel(selectedDate: date)
        plannerDetailView.dateLabel.text = viewModel?.dateLabelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = plannerDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        reloadCalendar?(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    deinit {
        print("deinit - PlannerDetailVC")
    }
}

private extension PlannerDetailViewController {
    func configure() {
        plannerDetailView.tableView.delegate = self
        plannerDetailView.tableView.dataSource = self
        plannerDetailView.inputTodoTextField.delegate = self
        
        plannerDetailView.addTodoButton.addTarget(
            self,
            action: #selector(didTappedAddTodoButton),
            for: .touchUpInside)
        plannerDetailView.editModeButton.addTarget(
            self,
            action: #selector(didTappedEditButton),
            for: .touchUpInside)
    }
    
    func bind() {
        plannerDetailView.inputTodoTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                self.plannerDetailView.addTodoButton.isEnabled = !text.isEmpty
            }
            .store(in: &subscriptions)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Todo 저장 실패",
                                      message: "잠시 후 다시 시도해 주세요.",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    @objc func didTappedAddTodoButton() {
        guard let viewModel = viewModel,
              let text = plannerDetailView.inputTodoTextField.text else { return }
        if viewModel.saveTodoResult(text: text) == true {
            plannerDetailView.tableView.reloadData()
        } else {
            showAlert()
        }
        plannerDetailView.inputTodoTextField.text?.removeAll()
        plannerDetailView.addTodoButton.isEnabled = false
    }
    
    @objc func didTappedEditButton() {
        let editing = plannerDetailView.tableView.isEditing
        plannerDetailView.tableView.setEditing(!editing, animated: true)
    }
}

extension PlannerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.shared.getTodoList(date: viewModel?.getDate).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlannerDetailTableViewCell.getIdentifier,
            for: indexPath
        ) as? PlannerDetailTableViewCell else { return UITableViewCell() }
        let todoList = TodoManager.shared.getTodoList(date: viewModel?.getDate)
        cell.configure(todo: todoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Todo"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTodo = TodoManager.shared.getTodoList(date: viewModel?.getDate)[indexPath.row]
        selectedTodo.done = !selectedTodo.done
        Task {
            if await TodoManager.shared.updateTodo(todo: selectedTodo) == true {
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let todo = TodoManager.shared.getTodoList(date: viewModel?.getDate)[indexPath.row]
        Task {
            if await TodoManager.shared.removeTodo(todo: todo) {
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath { return }
        Task {
            await TodoManager.shared.moveTodo(
                date: viewModel?.getDate,
                startIndex: sourceIndexPath.row,
                destinationIndex: destinationIndexPath.row
            )
        }
    }
}

extension PlannerDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

struct PlannerDetailVCPreView: PreviewProvider {
    static var previews: some View {
        let plannerDetailVC = PlannerDetailViewController(date: Date())
        plannerDetailVC.toPreview().edgesIgnoringSafeArea(.bottom)
    }
}
