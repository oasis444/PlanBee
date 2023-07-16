//
//  TodoTableViewCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    private static let identifier = "TodoTableViewCell"
    private let viewModel = TodoCellViewModel()
    private var todo: Todo?
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var todoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.todoTitleLabelFont
        label.textColor = viewModel.todoTitleLabelColor
        label.numberOfLines = viewModel.todoTitleNumberOfLines
        return label
    }()
    
    private lazy var alarmLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.alarmLabelFont
        label.textColor = viewModel.alarmLabelColor
        label.numberOfLines = viewModel.alarmLabelNumberOfLines
        return label
    }()
    
    private lazy var todoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = viewModel.stackViewSpacing
        
        [todoTitleLabel, alarmLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    func configure(todo: Todo) {
        self.todo = todo
        configureLayout()
        configureCell()
    }
}

private extension TodoTableViewCell {
    func configureLayout() {
        contentView.addSubview(todoStackView)
        
        todoStackView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().inset(viewModel.spacing)
        }
    }
    
    func configureCell() {
        let checkMarkImage = AccessoryImage().accessoryImage
        let accessoryImage: UIImageView? = todo?.done == true ? checkMarkImage : nil
        accessoryView = accessoryImage
        
        selectionStyle = .none
        
        todoTitleLabel.text = todo?.content
        
        if let alarmDate = todo?.alarm {
            alarmLabel.text = "⏰ 알림, " + DateFormatter.formatAlarmTime(date: alarmDate)
            todoStackView.spacing = viewModel.stackViewSpacing
        } else {
            alarmLabel.text = ""
            todoStackView.spacing = 0
        }
    }
}
