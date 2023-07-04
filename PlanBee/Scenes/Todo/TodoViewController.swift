//
//  TodoViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class TodoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTodoView()
    }
}

private extension TodoViewController {
    func configureTodoView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "일정"
    }
}
