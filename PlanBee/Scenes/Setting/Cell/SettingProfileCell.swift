//
//  SettingProfileCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SettingProfileCell: UITableViewCell {
    
    private static let identifier = "SettingProfileCell"
    let viewModel = SettingProfileCellViewModel()
    
    static var getIdentifier: String {
        return identifier
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = viewModel.defaultProfileImage
        return imageView
    }()
    
    private lazy var profileNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.profileNickNameFont
        label.textColor = viewModel.profileNickNameColor
        return label
    }()
    
    func configure() {
        configureCell()
        configureLayout()
    }
}

private extension SettingProfileCell {
    func configureCell() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        profileNickNameLabel.text = "플랜비"
    }
    
    func configureLayout() {
        [profileImageView, profileNickNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(viewModel.spacing)
            $0.top.bottom.equalToSuperview().inset(viewModel.spacing)
            $0.trailing.equalTo(profileNickNameLabel.snp.leading).offset(-viewModel.contentSpacing)
            $0.width.equalTo(viewModel.profileImageWidth)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        profileNickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(viewModel.contentSpacing)
            $0.trailing.equalToSuperview().inset(viewModel.spacing)
            $0.height.equalTo(profileImageView.snp.height)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
}
