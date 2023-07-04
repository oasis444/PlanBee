//
//  PlannerDetailTableViewCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class PlannerDetailTableViewCell: UITableViewCell {
    
    var todo: Todo?
    private static let identifier = "PlannerDetailTableViewCell"
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var todoTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    override func layoutSubviews() {
        configureLayout()
        todoTitle.text = todo?.content
    }
}

private extension PlannerDetailTableViewCell {
    func configureLayout() {
        let spacing: CGFloat = 16
        
        contentView.addSubview(todoTitle)
        
        todoTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(spacing)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
