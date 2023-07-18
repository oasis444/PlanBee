//
//  SettingTableViewCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {
    
    private static let identifier = "SettingTableViewCell"
    private let viewModel = SettingCellViewModel()
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.titleLabelFont
        label.textColor = viewModel.titleLabelColor
        return label
    }()
    
    func configureCell(title: String, icon: UIImage, iconColor: UIColor) {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        titleLabel.text = title
        iconImageView.image = icon
        iconImageView.tintColor = iconColor
        
        configureLayout()
    }
}

private extension SettingTableViewCell {
    func configureLayout() {
        [iconImageView, titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(viewModel.contentSpacing)
            $0.top.bottom.equalToSuperview().inset(viewModel.iconSpacing)
            $0.trailing.equalTo(titleLabel.snp.leading).offset(-viewModel.contentSpacing)
            $0.width.equalTo(iconImageView.snp.height)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(viewModel.contentSpacing)
            $0.top.bottom.equalToSuperview().inset(viewModel.spacing)
            $0.trailing.equalToSuperview().inset(viewModel.contentSpacing)
            $0.centerY.equalToSuperview()
        }
    }
}
