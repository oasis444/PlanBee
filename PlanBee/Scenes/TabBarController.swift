//
//  TabBarController.swift
//  PlanBee
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

private extension TabBarController {
    func configure() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        settingVC.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear")
        )
        
        viewControllers = [homeVC, settingVC]
        tabBar.tintColor = UIColor.mainTabBarTintColor
    }
}
