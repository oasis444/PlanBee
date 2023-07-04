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
    
    private lazy var addPlanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(didTappedAddPlanButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var inputTodoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.placeholder = "할 일을 추가해주세요"
        textField.backgroundColor = .systemBackground
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            PlannerDetailTableViewCell.self,
            forCellReuseIdentifier: PlannerDetailTableViewCell.getIdentifier
        )
        tableView.layer.cornerRadius = 15
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemRed
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // 아이템 간 간격 설정
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
        let contentSpacing: CGFloat = 50
        
        [dateLabel, addPlanButton, inputTodoTextField, tableView].forEach {
            view.addSubview($0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(spacing)
            $0.trailing.equalTo(addPlanButton.snp.leading)
        }
        
        addPlanButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(spacing)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        inputTodoTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(contentSpacing)
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.height.equalTo(contentSpacing)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(inputTodoTextField.snp.bottom).offset(contentSpacing)
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.bottom.equalToSuperview().inset(contentSpacing)
        }
    }
    
    @objc func didTappedAddPlanButton() {
        let todo = Todo(
            content: inputTodoTextField.text ?? "nil",
            date: self.date ?? Date()
        )
        let saveResult = viewModel.saveTodo(saveTodo: todo)
        if saveResult == true {
            dismiss(animated: true) {
                // PlannerVC의 캘린더 reload 시키기
                self.reloadCalendar?(true)
            }
        } else {
            showAlert()
        }
    }
}

private extension PlannerDetailViewController {
    func bind() {
        inputTodoTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .sink { text in
                self.addPlanButton.isEnabled = !text.isEmpty
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
        let selectedTodoList = viewModel.getSelectedTodoList(date: date)
        return selectedTodoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlannerDetailTableViewCell.getIdentifier,
            for: indexPath) as? PlannerDetailTableViewCell else { return UITableViewCell() }
        let selectedTodoList = viewModel.getSelectedTodoList(date: date)
        cell.todo = selectedTodoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Todo"
    }
}
