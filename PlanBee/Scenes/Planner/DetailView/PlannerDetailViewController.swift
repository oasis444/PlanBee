//
//  PlannerDetailViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine

final class PlannerDetailViewController: UIViewController {
    
    var date: Date?
    var reloadCalendar: ((_ relodaCalendar: Bool) -> Void)?
    private let viewModel = PlannerViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter
    }()
    
    private lazy var dateLabel: UILabel = {
        guard let date = date else { return UILabel() }
        let label = UILabel()
        label.text = dateFormatter.string(from: date)
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var addTodoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(didTappedAddTodoButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var inputTodoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.placeholder = "할 일을 추가해주세요"
        textField.backgroundColor = .systemBackground
        textField.delegate = self
        return textField
    }()
    
    private lazy var editModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTappedEditButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            PlannerDetailTableViewCell.self,
            forCellReuseIdentifier: PlannerDetailTableViewCell.getIdentifier
        )
        tableView.layer.cornerRadius = 15
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        subscriptions.removeAll()
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
    func configureView() {
        view.backgroundColor = .PlanBeeBackgroundColor
    }
    
    func configureLayout() {
        let spacing: CGFloat = 16
        let contentSpacing: CGFloat = 40
        
        [dateLabel, addTodoButton, inputTodoTextField, editModeButton, tableView].forEach {
            view.addSubview($0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(spacing)
            $0.trailing.equalTo(addTodoButton.snp.leading)
        }
        
        addTodoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(spacing)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        inputTodoTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(contentSpacing)
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.height.equalTo(contentSpacing)
        }
        
        editModeButton.snp.makeConstraints {
            $0.top.equalTo(inputTodoTextField.snp.bottom).offset(spacing)
            $0.trailing.equalToSuperview().inset(spacing)
            $0.bottom.equalTo(tableView.snp.top)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(editModeButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.bottom.equalToSuperview().inset(contentSpacing)
        }
    }
    
    @objc func didTappedAddTodoButton() {
        guard let text = inputTodoTextField.text else { return }
        if viewModel.textFieldIsFullWithBlank(text: text) == false {
            let todo = Todo(
                content: text,
                date: self.date ?? Date()
            )
            let saveResult = viewModel.saveTodo(saveTodo: todo)
            if saveResult == true {
                tableView.reloadData()
            } else {
                showAlert()
            }
        }
        inputTodoTextField.text?.removeAll()
        addTodoButton.isEnabled = false
    }
    
    @objc func didTappedEditButton() {
        let editing = tableView.isEditing
        tableView.setEditing(!editing, animated: true)
    }
}

private extension PlannerDetailViewController {
    func bind() {
        inputTodoTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .sink { text in
                self.addTodoButton.isEnabled = !text.isEmpty
            }
            .store(in: &subscriptions)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Todo 저장 실패", message: "잠시 후 다시 시도해 주세요.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

extension PlannerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedTodoList = viewModel.getTodoList(date: date)
        return selectedTodoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlannerDetailTableViewCell.getIdentifier,
            for: indexPath) as? PlannerDetailTableViewCell else { return UITableViewCell() }
        let selectedTodoList = viewModel.getTodoList(date: date)
        cell.configure(todo: selectedTodoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Todo"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTodo = viewModel.getTodoList(date: date)[indexPath.row]
        selectedTodo.done = !selectedTodo.done
        if viewModel.updateTodo(todo: selectedTodo) == true {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let todo = viewModel.getTodoList(date: date)[indexPath.row]
        if viewModel.removeTodo(todo: todo) {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath { return }
        viewModel.moveTodo(
            date: date,
            startIndex: sourceIndexPath.row,
            destinationIndex: destinationIndexPath.row
        )
    }
}

extension PlannerDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
