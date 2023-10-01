//
//  SettingCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit

final class SettingCell: UITableViewCell {
    private static let identifier = "SettingCell"
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        LabelFactory.makeLabel(
            text: nil,
            font: ThemeFont.demibold(size: 17))
    }()
    
    private lazy var stateTitleLabel: UILabel = {
        LabelFactory.makeLabel(
            text: nil,
            font: ThemeFont.demibold(size: 17),
            textColor: .lightGray,
            textAlignment: .right)
    }()
    
    private lazy var settingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
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
        
        setLayout()
    }
}

private extension SettingCell {
    func setLayout() {
        [iconImageView, titleLabel, stateTitleLabel].forEach {
            settingStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(settingStackView)
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        
        settingStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(AppConstraint.defaultSpacing)
        }
    }
}
