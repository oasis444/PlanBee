//
//  ProfileViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    let storeManager = FirestoreManager()
    
    private lazy var withdrawalBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(didTappedWithdrawalBtn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

private extension ProfileViewController {
    func configure() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .PlanBeeBackgroundColor
        
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(withdrawalBtn)
        
        withdrawalBtn.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    @objc func didTappedWithdrawalBtn() {
        print("didTapped")
    }
}
