//
//  ProfileDetailCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

class ProfileDetailCell: UITableViewCell {
    
    private static let identifier = "ProfileDetailCell"
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func configure(title: String) {
        selectionStyle = .none
        backgroundColor = ThemeColor.tableCellColor
        titleLabel.text = title
        
        configureLayout()
    }
}

private extension ProfileDetailCell {
    func configureLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
