//
//  VersionViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

class VersionViewController: UIViewController {
    
    private let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

private extension VersionViewController {
    func configure() {
        view.backgroundColor = ThemeColor.PlanBeeBackgroundColor
        versionLabel.text = version
        
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(versionLabel)
        
        versionLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
