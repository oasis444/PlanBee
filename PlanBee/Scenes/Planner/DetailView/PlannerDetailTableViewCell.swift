//
//  PlannerDetailTableViewCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class PlannerDetailTableViewCell: UITableViewCell {
    
    private static let identifier = "PlannerDetailTableViewCell"
    private let viewModel = PlannerDetailCellViewModel()
    private var todo: Todo?
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var todoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.todoTitleLabelFont
        label.textColor = viewModel.todoTitleLabelColor
        label.textAlignment = .left
        label.numberOfLines = viewModel.todoTitleLabelNumberOfLines
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
        contentView.addSubview(todoTitleLabel)
        
        todoTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(viewModel.spacing)
            $0.top.bottom.equalToSuperview().inset(viewModel.verticalSpacing)
            $0.trailing.equalToSuperview().inset(viewModel.spacing)
        }
    }
    
    func configureCell() {
        let checkMarkImage = AccessoryImage().accessoryImage
        let accessoryImage: UIImageView? = todo?.done == true ? checkMarkImage : nil
        accessoryView = accessoryImage
        
        selectionStyle = .none
        
        todoTitleLabel.text = todo?.content
    }
}
