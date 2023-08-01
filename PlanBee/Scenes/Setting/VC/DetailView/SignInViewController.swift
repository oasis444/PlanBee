//
//  SignInViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SignInViewController: UIViewController {
    
    private let viewModel = SignInViewModel()
    
    private lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.introLabelFont
        label.textColor = viewModel.introLabelColor
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var loginBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.loginBtnTitle, for: .normal)
        button.titleLabel?.font = viewModel.loginBtnFont
        button.addTarget(self, action: #selector(didTappedLoginBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.registerBtnTitle, for: .normal)
        button.titleLabel?.font = viewModel.registerBtnFont
        button.addTarget(self, action: #selector(didTappedRegisterBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = viewModel.stackViewSpacing
        
        [loginBtn, registerBtn].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .PlanBeeBackgroundColor
        
        introLabel.text = viewModel.introLabelText
        
        configureLayout()
    }
    
    deinit {
        print("deinit - ProfileVC")
    }
}

private extension SignInViewController {
    func configureLayout() {

        [introLabel, stackView].forEach {
            view.addSubview($0)
        }

        introLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(viewModel.spacing)
            $0.leading.trailing.equalToSuperview().inset(viewModel.spacing)
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(
                -introLabel.bounds.height +
                 (tabBarController?.tabBar.bounds.height ?? 0)
            )
        }
    }
    
    @objc func didTappedLoginBtn() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .flipHorizontal
        loginVC.configure(tapped: .login)
        loginVC.popToRootViewsClosure = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        present(loginVC, animated: true)
    }
    
    @objc func didTappedRegisterBtn() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .flipHorizontal
        loginVC.configure(tapped: .register)
        loginVC.popToRootViewsClosure = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        present(loginVC, animated: true)
    }
}
