//
//  LoginViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import FirebaseAuth
import Combine

enum LoginBtnType {
    case login
    case register
}

final class LoginViewController: UIViewController {
    
    let viewModel = LoginViewModel()
    let manager = FirebaseManager()
    var subscriptions = Set<AnyCancellable>()
    var popToRootViewsClosure: (() -> Void)?
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.hidesWhenStopped = true
        indicatorView.color = viewModel.indicatorColor
        return indicatorView
    }()
    
    private lazy var dismissBtn: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(didTappedDismissBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = viewModel.emailTextFieldPlaceholder
        textField.borderStyle = viewModel.textFieldStyle
        textField.textColor = viewModel.textFieldColor
        textField.font = viewModel.textFieldFont
        textField.keyboardType = viewModel.emailTextFieldKeyboardType
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = viewModel.passwordTextFieldPlaceholder
        textField.borderStyle = viewModel.textFieldStyle
        textField.textColor = viewModel.textFieldColor
        textField.font = viewModel.textFieldFont
        textField.keyboardType = viewModel.passwordTextFieldKeyboardType
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = viewModel.textFieldStackSpacing
        [emailTextField, passwordTextField].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = viewModel.separateViewColor
        return view
    }()
    
    private lazy var ageCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(viewModel.ageCheckBoxImage, for: .normal)
        button.tintColor = viewModel.ageCheckBoxColor
        button.imageView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewModel.ageCheckBoxInset)
        }
        button.tag = viewModel.ageCheckBoxTag
        button.addTarget(self, action: #selector(didTappedCheckBox(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var ageCheckLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.ageCheckLabelFont
        label.textAlignment = .left
        label.text = viewModel.ageCheckLabelText
        label.textColor = viewModel.ageCheckLabelColor
        return label
    }()
    
    private lazy var ageCheckStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = viewModel.ageCheckStackSpacing
        [ageCheckBox, ageCheckLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        ageCheckBox.snp.makeConstraints {
            $0.size.equalTo(viewModel.ageCheckBoxWidth)
        }
        return stackView
    }()
    
    private lazy var personalInfoCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(viewModel.personalInfoCheckBoxImage, for: .normal)
        button.tintColor = viewModel.personalInfoCheckBoxColor
        button.imageView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewModel.personalInfoCheckBoxInset)
        }
        button.tag = viewModel.personalInfoCheckBoxTag
        button.addTarget(self, action: #selector(didTappedCheckBox(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var personalInfoLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.personalInfoLabelTitle, for: .normal)
        button.titleLabel?.font = viewModel.personalInfoLabelFont
        button.tintColor = viewModel.personalInfoLabelColor
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var signUpBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = viewModel.signUpButtonFont
        button.setTitle(viewModel.signUpButtonTitle, for: .normal)
        button.backgroundColor = viewModel.signUpButtonBackgroundColor
        button.tintColor = viewModel.signUpButtonTintColor
        button.layer.cornerRadius = viewModel.signUpButtonRadius
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTappedSignUpBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var personalInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = viewModel.personalInfoStackSpacing
        [personalInfoCheckBox, personalInfoLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        personalInfoCheckBox.snp.makeConstraints {
            $0.size.equalTo(viewModel.personalInfoCheckBoxWidth)
        }
        return stackView
    }()
    
    private lazy var consentStack: UIView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = viewModel.consentStackSpacing
        [ageCheckStack, personalInfoStack].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func configure(tapped: LoginBtnType) {
        view.backgroundColor = .PlanBeeBackgroundColor
        viewModel.viewType = tapped
        configureLayout(type: tapped)
    }
    
    deinit {
        print("deint - LoginVC")
    }
}

private extension LoginViewController {
    func configureLayout(type: LoginBtnType) {
        
        [dismissBtn, textFieldStackView, separateView, signUpBtn, indicator].forEach {
            view.addSubview($0)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        dismissBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.defaultInset)
            $0.size.equalTo(viewModel.dismissBtnWidth)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(dismissBtn.snp.bottom).offset(viewModel.textFieldStackViewTopOffset)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.textFieldStackViewLeadTrailOffset)
            $0.bottom.equalTo(separateView.snp.top).offset(-viewModel.textFieldStackViewBottomOffset)
        }
        
        separateView.snp.makeConstraints {
            $0.height.equalTo(viewModel.separateViewHeight)
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(viewModel.separateViewTopOffset)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.separateViewLeadTrailOffset)
        }
        
        switch type {
        case .login:
            signUpBtn.snp.makeConstraints {
                $0.top.equalTo(separateView.snp.bottom).offset(viewModel.signUpBtnTopOffset)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.signUpBtnLeadTrailInset)
            }
            return
            
        case .register:
            [consentStack].forEach {
                view.addSubview($0)
            }
            
            consentStack.snp.makeConstraints {
                $0.top.equalTo(separateView.snp.bottom).offset(viewModel.consentStackTopOffset)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.consentStackLeadTrailOffset)
            }
            
            signUpBtn.snp.makeConstraints {
                $0.top.equalTo(consentStack.snp.bottom).offset(viewModel.signUpBtnTopOffset)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(viewModel.signUpBtnLeadTrailInset)
            }
            return
        }
    }
}

private extension LoginViewController {
    func bind() {
        emailTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)
        
        passwordTextField.textFieldPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.textFieldInputChecker
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                viewModel.textFieldIsFill = result
                
                switch viewModel.viewType {
                case .login:
                    if viewModel.textFieldIsFill {
                        viewModel.buttonON(button: signUpBtn)
                    } else {
                        viewModel.buttonOFF(button: signUpBtn)
                    }
                    return
                case .register:
                    if viewModel.textFieldIsFill && viewModel.checkBoxFill {
                        viewModel.buttonON(button: signUpBtn)
                    } else {
                        viewModel.buttonOFF(button: signUpBtn)
                    }
                    return
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc func didTappedSignUpBtn() {
        guard let email = emailTextField.text,
              email.isEmpty == false,
              let password = passwordTextField.text,
              password.isEmpty == false else { return }
        indicator.startAnimating()
        
        switch viewModel.viewType {
        case .login:
            manager.emailLogIn(email: email, password: password) { [weak self] firebaseError in
                guard let self = self else { return }
                self.indicator.stopAnimating()
                
                if let error = firebaseError {
                    self.showAlert(title: "로그인 실패", error: error)
                    return
                }
                self.dismiss(animated: true) {
                    self.popToRootViewsClosure?()
                }
            }
            
            return
        case .register:
            manager.createUsers(email: email, password: password) { [weak self] firebaseError in
                guard let self = self else { return }
                self.indicator.stopAnimating()
                
                if let error = firebaseError {
                    self.showAlert(title: "회원가입 실패", error: error)
                    return
                }
                self.welcomPlanBee(title: "🎉 회원가입 완료 🎉", message: "플랜비에 오신 것을 환영합니다.")
            }
            return
        }
    }
    
    func welcomPlanBee(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.popToRootViewsClosure?()
            }
        }
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func showAlert(title: String, error: FirebaseErrors) {
        let alert = UIAlertController(title: title, message: error.errorMessage, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    @objc func didTappedCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let tintColor: UIColor = sender.isSelected ? .systemPink : .lightGray
        sender.tintColor = tintColor
        
        if ageCheckBox.isSelected && personalInfoCheckBox.isSelected {
            viewModel.checkBoxFill = true
            if viewModel.textFieldIsFill && viewModel.checkBoxFill {
                viewModel.buttonON(button: signUpBtn)
            }
        } else {
            viewModel.checkBoxFill = false
            viewModel.buttonOFF(button: signUpBtn)
        }
    }
    
    @objc func didTappedDismissBtn() {
        dismiss(animated: true)
    }
}
