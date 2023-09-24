//
//  AccessoryImage.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

struct AccessoryImage {
    static var accessoryImage: UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        imageView.tintColor = ThemeColor.PlanBeeTintColor
        return imageView
    }
}
