//
//  SettingViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

final class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

private extension SettingViewController {
    func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title  = "설정"
        
    }
}
