//
//  TodoViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SwiftUI

final class TodoViewController: UIViewController {
    
    private let todoView = TodoView()
    private let viewModel = TodoViewModel()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "편집",
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTappedRightBarBtn))
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        view = todoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        todoView.tableView.reloadData()
    }
}

private extension TodoViewController {
    func configure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "오늘 일정"
        navigationItem.rightBarButtonItem = rightBarButton
        
        todoView.tableView.dataSource = self
        todoView.tableView.delegate = self
    }
    
    @objc func didTappedRightBarBtn() {
        let editing = todoView.tableView.isEditing
        if viewModel.getTodoList.isEmpty { return }
        todoView.tableView.setEditing(!editing, animated: true)
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTodoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoTableViewCell.getIdentifier,
            for: indexPath
        ) as? TodoTableViewCell else { return UITableViewCell() }
        let todoList = viewModel.getTodoList
        cell.configure(todo: todoList[indexPath.row])
        cell.backgroundColor = ThemeColor.tableCellColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            let result = await viewModel.updateTodo(index: indexPath.row)
            if result {
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        Task {
            let result = await viewModel.removeTodo(index: indexPath.row)
            if result {
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAlarmAction = UIContextualAction(style: .normal,
                                                title: "알림 설정") { [weak self] _, _, _ in
            guard let self = self else { return }
            let alarmVC = AlarmViewController()
            let todoList = viewModel.getTodoList
            alarmVC.configure(todo: todoList[indexPath.row])
            
            alarmVC.reloadTodoTableView = { [weak self] result in
                guard let self = self else { return }
                if result {
                    DispatchQueue.main.async {
                        self.todoView.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            self.present(alarmVC, animated: true)
        }
        addAlarmAction.image = UIImage(systemName: "alarm")
        return UISwipeActionsConfiguration(actions: [addAlarmAction])
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath { return }
        viewModel.moveTodo(startIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.todoHeaderTitle
    }
}

struct TodoVCPreView: PreviewProvider {
    static var previews: some View {
        let todoVC = TodoViewController()
        UINavigationController(rootViewController: todoVC)
            .toPreview().edgesIgnoringSafeArea(.all)
    }
}
