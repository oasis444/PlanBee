//
//  SettingCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SettingCell: UITableViewCell {
    
    private static let identifier = "SettingCell"
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
    
    private lazy var stateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.stateTitleFont
        label.textColor = viewModel.stateTitleColor
        label.textAlignment = .right
        return label
    }()
    
    private lazy var settingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = viewModel.settingStackViewSpacing
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    func configureCell(title: String?, iconImage: UIImage?, iconColor: UIColor?, screenMode: String? = nil) {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = ThemeColor.tableCellColor
        
        iconImageView.image = iconImage
        iconImageView.tintColor = iconColor
        titleLabel.text = title
        stateTitleLabel.text = screenMode
        
        configureLayout()
    }
}

private extension SettingCell {
    func configureLayout() {
        [iconImageView, titleLabel, stateTitleLabel].forEach {
            settingStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(settingStackView)
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(viewModel.iconImageWidth)
        }
        
        settingStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewModel.settingStackViewInset)
        }
    }
}
