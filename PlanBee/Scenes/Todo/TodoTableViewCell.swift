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
    private let spacing: CGFloat = 16
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    func configure(todo: Todo) {
        self.todo = todo
        configureLayout()
        configureCell()
    }
}

private extension TodoTableViewCell {
    func configureLayout() {
        contentView.addSubview(title)
        
        title.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(spacing)
        }
    }
    
    func configureCell() {
        let checkMarkImage = AccessoryImage().accessoryImage
        let accessoryImage: UIImageView? = todo?.done == true ? checkMarkImage : nil
        accessoryView = accessoryImage
        
        selectionStyle = .none
        
        title.text = todo?.content
    }
}
