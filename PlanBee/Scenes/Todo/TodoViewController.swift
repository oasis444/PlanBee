//
//  TodoViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit

final class TodoViewController: UIViewController {
    
    private let todoManager = TodoManager()
    private let viewModel = TodoViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .PlanBeeBackgroundColor
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.getIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTodoView()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

private extension TodoViewController {
    func configureTodoView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.todoTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: viewModel.navigationRightBtnTitle,
            style: .plain,
            target: self,
            action: #selector(didTappedRightBarBtn)
        )
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func didTappedRightBarBtn() {
        let editing = tableView.isEditing
        let todoList = todoManager.getTodoList(date: Date())
        if todoList.isEmpty { return }
        tableView.setEditing(!editing, animated: true)
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.getTodoList(date: Date()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoTableViewCell.getIdentifier,
            for: indexPath
        ) as? TodoTableViewCell else { return UITableViewCell() }
        let todoList = todoManager.getTodoList(date: Date())
        cell.configure(todo: todoList[indexPath.row])
        cell.backgroundColor = .systemGray5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTodo = todoManager.getTodoList(date: Date())[indexPath.row]
        selectedTodo.done = !selectedTodo.done
        Task {
            if await todoManager.updateTodo(todo: selectedTodo) == true {
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let todo = todoManager.getTodoList(date: Date())[indexPath.row]
        Task {
            if await todoManager.removeTodo(todo: todo) {
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAlarmAction = UIContextualAction(style: .normal,
                                                title: viewModel.alarmActionTitle) { [weak self] _, _, _ in
            guard let self = self else { return }
            let alarmVC = AlarmViewController()
            let todoList = todoManager.getTodoList(date: Date())
            alarmVC.todo = todoList[indexPath.row]
            alarmVC.reloadTodoTableView = { [weak self] result in
                guard let self = self else { return }
                if result {
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            self.present(alarmVC, animated: true)
        }
        addAlarmAction.image = viewModel.alarmActionImage
        return UISwipeActionsConfiguration(actions: [addAlarmAction])
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath { return }
        Task {
            await todoManager.moveTodo(
                date: Date(),
                startIndex: sourceIndexPath.row,
                destinationIndex: destinationIndexPath.row
            )
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.todoHeaderTitle
    }
}
