//
//  TodoTableViewCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    private static let identifier = "TodoTableViewCell"
    private var todo: Todo?
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var todoTitleLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: nil,
            font: ThemeFont.bold(size: 30),
            textAlignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var alarmLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: nil,
            font: ThemeFont.demibold(size: 17),
            textColor: .darkGray,
            textAlignment: .left)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var todoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        [todoTitleLabel, alarmLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
}

extension TodoTableViewCell {
    func configure(todo: Todo) {
        self.todo = todo
        setLayout()
        configCell()
    }
}

private extension TodoTableViewCell {
    func setLayout() {
        contentView.addSubview(todoStackView)
        
        todoStackView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().inset(AppConstraint.defaultSpacing)
        }
    }
    
    func configCell() {
        let checkMarkImage = AccessoryImage.accessoryImage
        let accessoryImage: UIImageView? = todo?.done == true ? checkMarkImage : nil
        accessoryView = accessoryImage
        selectionStyle = .none
        
        todoTitleLabel.text = todo?.content
        
        if let alarmDate = todo?.alarm {
            alarmLabel.text = "⏰ 알림, " + DateFormatter.formatAlarmTime(date: alarmDate)
            todoStackView.spacing = AppConstraint.stackViewSpacing
        } else {
            alarmLabel.text = ""
            todoStackView.spacing = 0
        }
    }
}
