//
//  SettingViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingView()
    }
}

private extension SettingViewController {
    func configureSettingView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title  = "설정"
    }
}
