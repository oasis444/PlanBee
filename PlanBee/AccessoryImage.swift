//
//  AccessoryImage.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class AccessoryImage {
    var accessoryImage: UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        imageView.tintColor = .PlanBeetintColor
        return imageView
    }
}
