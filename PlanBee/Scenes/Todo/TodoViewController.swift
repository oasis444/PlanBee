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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.navigationLeftBtnTitle,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTappedLeftBarBtn))
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func didTappedLeftBarBtn() {
        let editing = tableView.isEditing
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
        if todoManager.updateTodo(todo: selectedTodo) == true {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let todo = todoManager.getTodoList(date: Date())[indexPath.row]
        if todoManager.removeTodo(todo: todo) {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let addAlarmAction = UIContextualAction(style: .normal, title: viewModel.alarmActionTitle) {_, _, _ in
            let alarmVC = AlarmViewController()
//            self.present(alarmVC, animated: true)
            self.navigationController?.pushViewController(alarmVC, animated: true)
        }
        addAlarmAction.image = viewModel.alarmActionImage
        return UISwipeActionsConfiguration(actions: [addAlarmAction])
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath { return }
        todoManager.moveTodo(
            date: Date(),
            startIndex: sourceIndexPath.row,
            destinationIndex: destinationIndexPath.row
        )
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.todoHeaderTitle
    }
}
