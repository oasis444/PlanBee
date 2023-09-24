//
//  ProfileCell.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class ProfileCell: UITableViewCell {
    private static let identifier = "ProfileCell"
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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = viewModel.profileStackViewSpacing
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileCell {
    func configureCell() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = ThemeColor.tableCellColor
        
        profileNickNameLabel.text = FirebaseManager.shared.getUserEmail()
    }
    
    func configureLayout() {
        [profileImageView, profileNickNameLabel].forEach {
            profileStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(profileStackView)
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(viewModel.profileImageWidth)
        }
        
        profileStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewModel.profileStackViewInset)
        }
    }
}
