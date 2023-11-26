//
//  PlannerDetailView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SnapKit
import UIKit

final class PlannerDetailView: UIView {
    lazy var dateLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: nil,
            font: ThemeFont.bold(size: 30),
            textAlignment: .left)
        return label
    }()
    
    lazy var addTodoButton: UIButton = {
        let button = ButtonFactory.makeButton(
            image: UIImage(systemName: "plus.circle"),
            tintColor: .systemBlue)
        button.isEnabled = false
        return button
    }()
    
    lazy var inputTodoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.placeholder = "할 일을 추가해주세요"
        textField.backgroundColor = .systemBackground
        return textField
    }()
    
    lazy var editModeButton: UIButton = {
        let button = ButtonFactory.makeButton(
            title: "편집",
            titleColor: .systemBlue
        )
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            PlannerDetailTableViewCell.self,
            forCellReuseIdentifier: PlannerDetailTableViewCell.getIdentifier
        )
        tableView.layer.cornerRadius = 15
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = ThemeColor.PlanBeeBackgroundColor
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PlannerDetailView {
    func setLayout() {
        [dateLabel, addTodoButton, inputTodoTextField, editModeButton, tableView].forEach {
            self.addSubview($0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(AppConstraint.defaultSpacing)
            $0.trailing.equalTo(addTodoButton.snp.leading)
        }
        
        addTodoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(AppConstraint.defaultSpacing)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        inputTodoTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(AppConstraint.defaultSpacing)
            $0.height.equalTo(40)
        }
        
        editModeButton.snp.makeConstraints {
            $0.top.equalTo(inputTodoTextField.snp.bottom).offset(AppConstraint.defaultSpacing)
            $0.trailing.equalToSuperview().inset(AppConstraint.defaultSpacing)
            $0.bottom.equalTo(tableView.snp.top)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(editModeButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(AppConstraint.defaultSpacing)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
