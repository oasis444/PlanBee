//
//  SettingProfileCellViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SettingProfileCellViewModel {
    let profileImageWidth: CGFloat = 80
    
    let defaultProfileImage: UIImage = UIImage(systemName: "person.fill") ?? UIImage()
    
    let profileNickNameFont: UIFont = .systemFont(ofSize: 25, weight: .medium)
    let profileNickNameColor: UIColor = .label
    
    let profileStackViewSpacing: CGFloat = 20
    let profileStackViewInset: CGFloat = 16
}
