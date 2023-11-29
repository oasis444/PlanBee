//
//  VersionViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

class VersionViewController: UIViewController {
    private let versionView = VersionView()
    
    override func loadView() {
        super.loadView()
        
        view = versionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit - VersionVC")
    }
}
