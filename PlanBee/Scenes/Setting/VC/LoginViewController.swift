//
//  LoginViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Combine
import FirebaseAuth
import SafariServices
import SwiftUI
import UIKit

final class LoginViewController: UIViewController {
    private let loginView: LoginView
    private let viewModel: LoginViewModel
    var subscriptions = Set<AnyCancellable>()
    var popToRootViewsClosure: (() -> Void)?
    
    override func loadView() {
        super.loadView()
        
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setButtonTarget()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    init(buttonType: LoginBtnType, title: String) {
        loginView = LoginView(buttonType: buttonType, title: title)
        viewModel = LoginViewModel(loginButtonType: buttonType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deint - LoginVC")
    }
}

extension LoginViewController {
    func configure(tapped: LoginBtnType) {
        view.backgroundColor = ThemeColor.PlanBeeBackgroundColor
    }
}

private extension LoginViewController {
    func setButtonTarget() {
        loginView.dismissBtn.addTarget(
            self,
            action: #selector(didTappedDismissBtn),
            for: .touchUpInside)
        
        loginView.ageCheckBox.addTarget(
            self,
            action: #selector(didTappedCheckBox),
            for: .touchUpInside)
        
        loginView.personalInfoCheckBox.addTarget(
            self,
            action: #selector(didTappedCheckBox),
            for: .touchUpInside)
        
        loginView.signUpBtn.addTarget(
            self,
            action: #selector(didTappedSignUpBtn),
            for: .touchUpInside)
        
        loginView.privacyInfoButton.addTarget(
            self,
            action: #selector(didTappedPrivacyInfoBtn),
            for: .touchUpInside)
    }
    
    func bind() {
        loginView.emailTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)
        
        loginView.passwordTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
        
        loginView.passwordConfirmTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordConfirm, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.textFieldInputChecker
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.viewModel.textFieldIsFill = result
                
                switch viewModel.viewType {
                case .login:
                    if viewModel.textFieldIsFill {
                        buttonON(button: loginView.signUpBtn)
                        return
                    }
                    buttonOFF(button: loginView.signUpBtn)
                    
                case .register:
                    if viewModel.textFieldIsFill && viewModel.checkBoxFill {
                        buttonON(button: loginView.signUpBtn)
                        return
                    }
                    buttonOFF(button: loginView.signUpBtn)
                }
            }
            .store(in: &subscriptions)
        
        viewModel.errorSubject.sink { [weak self] title, error in
            guard let self = self else { return }
            loginView.indicator.stopAnimating()
            let alert = AlertFactory.makeAlert(
                title: title,
                message: error.errorMessage,
                firstActionTitle: "확인",
                firstActionCompletion: { [weak self] in
                    guard let self = self else { return }
                    self.loginView.signUpBtn.isEnabled = true
                })
            present(alert, animated: true)
        }.store(in: &subscriptions)
    }
    
    @objc func didTappedSignUpBtn(_ sender: UIButton) {
        guard let email = loginView.emailTextField.text, email.isEmpty == false,
              let password = loginView.passwordTextField.text, password.isEmpty == false else { return }
        
        loginView.signUpBtn.isEnabled = false
        loginView.indicator.startAnimating()
        
        switch viewModel.viewType {
        case .login:
            viewModel.login(email: email, password: password) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.loginView.indicator.stopAnimating()
                    if result {
                        if self.viewModel.checkReturnUser {
                            self.present(self.returnPlanBeeAlert, animated: true)
                            return
                        }
                        self.present(self.loginAlert, animated: true)
                    }
                }
            }
            
        case .register:
            viewModel.register(email: email, password: password) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.loginView.indicator.stopAnimating()
                    if result {
                        self.present(self.welcomAlert, animated: true)
                        return
                    }
                    self.present(self.signUpFailAlert, animated: true)
                }
            }
        }
    }
    
    @objc func didTappedCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let tintColor: UIColor = sender.isSelected ? .systemPink : .lightGray
        sender.tintColor = tintColor
        
        if loginView.ageCheckBox.isSelected && loginView.personalInfoCheckBox.isSelected {
            viewModel.checkBoxFill = true
            if viewModel.textFieldIsFill && viewModel.checkBoxFill {
                buttonON(button: loginView.signUpBtn)
            }
            return
        }
        viewModel.checkBoxFill = false
        buttonOFF(button: loginView.signUpBtn)
    }

    @objc func didTappedDismissBtn() {
        dismiss(animated: true)
    }
    
    func buttonON(button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = .systemIndigo
    }
    
    func buttonOFF(button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .lightGray
    }
    
    @objc func didTappedPrivacyInfoBtn() {
        if let url = URL(string: PRIVACY) {
            let privacyVC = SFSafariViewController(url: url)
            present(privacyVC, animated: true)
        }
    }
}

private extension LoginViewController {
    var welcomAlert: UIAlertController {
        let alert = AlertFactory.makeAlert(
            title: "🎉 회원가입 완료 🎉",
            message: "플랜비에 오신 것을 환영합니다.",
            firstActionTitle: "확인",
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.popToRootViewsClosure?()
                }
            })
        return alert
    }
    
    var signUpFailAlert: UIAlertController {
        let alert = AlertFactory.makeAlert(
            title: "회원가입 실패",
            message: "회원 가입에 실패하였습니다. 잠시 후 다시 시도해 주세요.",
            firstActionTitle: "확인",
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                self.loginView.signUpBtn.isEnabled = true
            })
        return alert
    }
    
    var loginAlert: UIAlertController {
        let alert = AlertFactory.makeAlert(
            title: "🎉 로그인 완료 🎉",
            message: "플랜비에 오신 것을 환영합니다.",
            firstActionTitle: "확인",
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.popToRootViewsClosure?()
                }
            })
        return alert
    }
    
    var returnPlanBeeAlert: UIAlertController {
        let alert = AlertFactory.makeAlert(
            title: "🎉 복귀를 환영합니다 🎉",
            message: "최근 6개월간 데이터를 저장했습니다.",
            firstActionTitle: "확인",
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                UserDefaultsManager.shared.setValue(value: false, key: "isReturnUser")
                self.dismiss(animated: true) {
                    self.popToRootViewsClosure?()
                }
            })
        return alert
    }
}

struct LoginVCPreView: PreviewProvider {
    static var previews: some View {
        let loginVC = LoginViewController(buttonType: .register, title: "회원가입")
        UINavigationController(rootViewController: loginVC)
            .toPreview().edgesIgnoringSafeArea(.all)
    }
}
