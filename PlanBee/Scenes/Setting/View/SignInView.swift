//
//  SignInView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SignInView: UIView {
    private lazy var introLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: """
        플랜비에 처음 오셨나요?
        
        회원 가입을 하면 언제 어디서든
        저장된 정보를 가져올 수 있습니다.
        """,
            font: ThemeFont.bold(size: 27),
            textAlignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var loginBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        return button
    }()
    
    lazy var registerBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        
        [loginBtn, registerBtn].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SignInView {
    func setLayout() {
        [introLabel, stackView].forEach {
            self.addSubview($0)
        }

        introLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.safeAreaLayoutGuide).offset(50)
        }
    }
}
