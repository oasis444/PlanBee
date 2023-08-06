//
//  PlannerDetailViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine

final class PlannerDetailViewController: UIViewController {
    
    var reloadCalendar: ((_ relodaCalendar: Bool) -> Void)?
    private let todoManager = TodoManager()
    private let storeManager = FirestoreManager()
    private var viewModel: PlannerDetailViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    init(date: Date) {
        super.init(nibName: nil, bundle: nil)
        viewModel = PlannerDetailViewModel(selectedDate: date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel?.dateLabelFont
        label.text = viewModel?.dateLabelText
        label.textColor = viewModel?.dateLabelTextColor
        return label
    }()
    
    private lazy var addTodoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(viewModel?.addTodoBtnImage, for: .normal)
        button.addTarget(self, action: #selector(didTappedAddTodoButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var inputTodoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = viewModel?.textFieldBorderStyle ?? .roundedRect
        textField.font = viewModel?.textFieldFont
        textField.placeholder = viewModel?.textFieldPlaceHolderText
        textField.backgroundColor = viewModel?.textFieldBackgoundColor
        textField.delegate = self
        return textField
    }()
    
    private lazy var editModeButton: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel?.editBtnTitle, for: .normal)
        button.setTitleColor(viewModel?.editBtnTitleColor, for: .normal)
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
        tableView.layer.cornerRadius = viewModel?.tableViewCornerRadius ?? 15
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
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
    func configureView() {
        view.backgroundColor = .PlanBeeBackgroundColor
    }
    
    func configureLayout() {
        [dateLabel, addTodoButton, inputTodoTextField, editModeButton, tableView].forEach {
            view.addSubview($0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(viewModel?.layoutSpacing ?? 16)
            $0.trailing.equalTo(addTodoButton.snp.leading)
        }
        
        addTodoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(viewModel?.layoutSpacing ?? 26)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        inputTodoTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(viewModel?.layoutContentSpacing ?? 16)
            $0.leading.trailing.equalToSuperview().inset(viewModel?.layoutSpacing ?? 40)
            $0.height.equalTo(viewModel?.layoutContentSpacing ?? 40)
        }
        
        editModeButton.snp.makeConstraints {
            $0.top.equalTo(inputTodoTextField.snp.bottom).offset(viewModel?.layoutSpacing ?? 16)
            $0.trailing.equalToSuperview().inset(viewModel?.layoutSpacing ?? 16)
            $0.bottom.equalTo(tableView.snp.top)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(editModeButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(viewModel?.layoutSpacing ?? 16)
            $0.bottom.equalToSuperview().inset(viewModel?.layoutContentSpacing ?? 40)
        }
    }
    
    @objc func didTappedAddTodoButton() {
        guard let date = viewModel?.getDate,
              let text = inputTodoTextField.text else { return }
        if todoManager.textFieldIsFullWithBlank(text: text) == false {
            let strDate = DateFormatter.formatTodoDate(date: date)
            let todo = Todo(
                content: text,
                date: strDate
            )
            let saveResult = todoManager.saveTodo(saveTodo: todo)
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
            .sink { [weak self] text in
                self?.addTodoButton.isEnabled = !text.isEmpty
            }
            .store(in: &subscriptions)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: viewModel?.alertTitle,
                                      message: viewModel?.alertMessage,
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: viewModel?.alertActionTitle, style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

extension PlannerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.getTodoList(date: viewModel?.getDate).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlannerDetailTableViewCell.getIdentifier,
            for: indexPath
        ) as? PlannerDetailTableViewCell else { return UITableViewCell() }
        let todoList = todoManager.getTodoList(date: viewModel?.getDate)
        cell.configure(todo: todoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.tableViewHeaderTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedTodo = todoManager.getTodoList(date: viewModel?.getDate)[indexPath.row]
        selectedTodo.done = !selectedTodo.done
        Task {
            if await todoManager.updateTodo(todo: selectedTodo) == true {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let todo = todoManager.getTodoList(date: viewModel?.getDate)[indexPath.row]
        Task {
            if await todoManager.removeTodo(todo: todo) {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath { return }
        Task {
            await todoManager.moveTodo(
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
