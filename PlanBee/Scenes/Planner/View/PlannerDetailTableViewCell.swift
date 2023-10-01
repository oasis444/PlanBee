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
    
    private lazy var todoTitleLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: nil,
            font: ThemeFont.regular(size: 23),
            textAlignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    func configure(todo: Todo?) {
        self.todo = todo
        setLayout()
        configureCell()
    }
}

private extension PlannerDetailTableViewCell {
    func setLayout() {
        contentView.addSubview(todoTitleLabel)
        
        todoTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(AppConstraint.defaultSpacing)
            $0.top.bottom.equalToSuperview().inset(AppConstraint.defaultSpacing)
            $0.trailing.equalToSuperview().inset(AppConstraint.defaultSpacing)
        }
    }
    
    func configureCell() {
        let checkMarkImage = AccessoryImage.accessoryImage
        let accessoryImage: UIImageView? = todo?.done == true ? checkMarkImage : nil
        accessoryView = accessoryImage
        
        selectionStyle = .none
        
        todoTitleLabel.text = todo?.content
    }
}
