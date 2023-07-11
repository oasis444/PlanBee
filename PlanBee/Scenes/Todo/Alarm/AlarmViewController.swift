//
//  AlarmViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class AlarmViewController: UIViewController {
    
    let viewModel = AlarmViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    deinit {
        print("deinit - AlarmVC")
    }
}

private extension AlarmViewController {
    func configureView() {
        view.backgroundColor = .PlanBeeBackgroundColor
        navigationItem.title = viewModel.alarmViewNavigationTitle
    }
}
