//
//  TabBarController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
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
        let todoVC = UINavigationController(rootViewController: TodoViewController())
        todoVC.tabBarItem = UITabBarItem(
            title: "일정",
            image: UIImage(systemName: "checklist"),
            selectedImage: UIImage(systemName: "checklist.checked")
        )
        
        let plannerVC = UINavigationController(rootViewController: PlannerViewController())
        plannerVC.tabBarItem = UITabBarItem(
            title: "플래너",
            image: UIImage(systemName: "calendar.badge.plus"),
            selectedImage: UIImage(systemName: "calendar")
        )
        
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        settingVC.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear")
        )
        viewControllers = [todoVC, plannerVC, settingVC]
        tabBar.tintColor = ThemeColor.mainTabBarTintColor
    }
}
