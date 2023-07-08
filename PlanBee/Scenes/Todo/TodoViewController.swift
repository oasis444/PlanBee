//
//  TodoViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit

final class TodoViewController: UIViewController {
    
    let viewModel = TodoManager()
    
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
        navigationItem.title = "오늘 일정"
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTodoList(date: Date()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoTableViewCell.getIdentifier,
            for: indexPath
        ) as? TodoTableViewCell else { return UITableViewCell() }
        let todoList = viewModel.getTodoList(date: Date())
        cell.configure(todo: todoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTodo = viewModel.getTodoList(date: Date())[indexPath.row]
        selectedTodo.done = !selectedTodo.done
        if viewModel.updateTodo(todo: selectedTodo) == true {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let todo = viewModel.getTodoList(date: Date())[indexPath.row]
        if viewModel.removeTodo(todo: todo) {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath { return }
        viewModel.moveTodo(
            date: Date(),
            startIndex: sourceIndexPath.row,
            destinationIndex: destinationIndexPath.row
        )
    }
}
