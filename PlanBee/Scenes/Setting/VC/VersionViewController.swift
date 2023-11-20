//
//  VersionViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SwiftUI
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
}

struct VersionVCPreView: PreviewProvider {
    static var previews: some View {
        let versionVC = VersionViewController()
        UINavigationController(rootViewController: versionVC)
            .toPreview().edgesIgnoringSafeArea(.all)
    }
}
