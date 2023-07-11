//
//  SettingViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SettingViewController: UIViewController {
    
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingView()
    }
}

private extension SettingViewController {
    func configureSettingView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.settingViewNavigationTitle
    }
}
