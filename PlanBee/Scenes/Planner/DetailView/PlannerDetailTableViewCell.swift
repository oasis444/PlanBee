//
//  PlannerDetailTableViewCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class PlannerDetailTableViewCell: UITableViewCell {
    
    private static let identifier = "PlannerDetailTableViewCell"
    private var todo: Todo?
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var todoTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    func configure(todo: Todo?) {
        self.todo = todo
        configureLayout()
        configureCell()
    }
}

private extension PlannerDetailTableViewCell {
    func configureLayout() {
        let spacing: CGFloat = 16
        let verticalSpacing: CGFloat = 15
        
        contentView.addSubview(todoTitle)
        
        todoTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(spacing)
            $0.top.bottom.equalToSuperview().inset(verticalSpacing)
            $0.trailing.equalToSuperview().inset(spacing)
        }
    }
    
    func configureCell() {
        selectionStyle = .none
        
        let type: UITableViewCell.AccessoryType = todo?.done == true ? .checkmark : .none
        accessoryType = type
        
        todoTitle.text = todo?.content
    }
}
