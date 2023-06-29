//
//  HomeViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

private extension HomeViewController {
    func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "홈"
    }
}
