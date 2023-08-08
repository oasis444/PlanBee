//
//  RevokeViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

class RevokeViewController: UIViewController {
    
    let warningText = """
                    탈퇴를 하면 계정 삭제 및
                    사용자의 정보가 모두 삭제가 됩니다.
                    """
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .systemPink
        label.textAlignment = .left
        label.text = warningText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var revokeBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("탈퇴하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.systemPink, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension RevokeViewController {
    func configure() {
        view.backgroundColor = .PlanBeeBackgroundColor
        
        configureLayout()
    }
    
    func configureLayout() {
        [warningLabel, revokeBtn].forEach {
            view.addSubview($0)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        revokeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.centerY.equalToSuperview().offset(100)
        }
    }
}
