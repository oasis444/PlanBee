//
//  LoginView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit

final class LoginView: UIView {
    private let buttonType: LoginBtnType
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.hidesWhenStopped = true
        indicatorView.color = ThemeColor.indicatorColor
        return indicatorView
    }()
    
    lazy var dismissBtn: UIButton = {
        let button = ButtonFactory.makeButton(type: .close)
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일 입력"
        textField.borderStyle = .roundedRect
        textField.textColor = .label
        textField.font = ThemeFont.regular(size: 22)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 입력"
        textField.borderStyle = .roundedRect
        textField.textColor = .label
        textField.font = ThemeFont.regular(size: 22)
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var passwordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 입력 확인"
        textField.borderStyle = .roundedRect
        textField.textColor = .label
        textField.font = ThemeFont.regular(size: 22)
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        switch buttonType {
        case .login:
            [emailTextField, passwordTextField].forEach {
                stackView.addArrangedSubview($0)
            }
        case .register:
            [emailTextField, passwordTextField, passwordConfirmTextField].forEach {
                stackView.addArrangedSubview($0)
            }
        }
        return stackView
    }()
    
    private lazy var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        return view
    }()
    
    lazy var ageCheckBox: UIButton = {
        let button = ButtonFactory.makeButton(
            type: .custom,
            image: UIImage(systemName: "checkmark.square"),
            tintColor: .lightGray)
        button.tag = 0
        return button
    }()
    
    private lazy var ageCheckLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: "만 14세 이상입니다.",
            font: ThemeFont.bold(size: 22),
            textAlignment: .left)
        return label
    }()
    
    private lazy var ageCheckStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        
        [ageCheckBox, ageCheckLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    lazy var personalInfoCheckBox: UIButton = {
        let button = ButtonFactory.makeButton(
            type: .custom,
            image: UIImage(systemName: "checkmark.square"),
            tintColor: .lightGray)
        button.tag = 0
        return button
    }()
    
    lazy var personalInfoLabel: UIButton = {
        let button = ButtonFactory.makeButton(
            title: "개인정보 수집 이용 및 동의서",
            titleLabelFont: ThemeFont.bold(size: 22),
            titleColor: .systemPink)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var signUpBtn: UIButton = {
        let button = ButtonFactory.makeButton(
            titleLabelFont: ThemeFont.bold(size: 25),
            titleColor: .white,
            backgroundColor: .lightGray,
            cornerRadius: 10)
        button.isEnabled = false
        return button
    }()
    
    private lazy var personalInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        
        [personalInfoCheckBox, personalInfoLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var consentStack: UIView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        [ageCheckStack, personalInfoStack].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    init(buttonType: LoginBtnType, title: String) {
        self.buttonType = buttonType
        super.init(frame: .zero)
        self.signUpBtn.setTitle(title, for: .normal)
        setLayout()
        configTypeOfLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoginView {
    func setLayout() {
        [indicator, dismissBtn, textFieldStackView, separateView, signUpBtn].forEach {
            self.addSubview($0)
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        dismissBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(AppConstraint.defaultSpacing)
            $0.size.equalTo(40)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(dismissBtn.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(50)
            $0.bottom.equalTo(separateView.snp.top).offset(-30)
        }
        
        separateView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(50)
        }
        
        ageCheckBox.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        ageCheckBox.imageView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        personalInfoCheckBox.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        personalInfoCheckBox.imageView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func configTypeOfLayout() {
        switch buttonType {
        case .login:
            signUpBtn.snp.makeConstraints {
                $0.top.equalTo(separateView.snp.bottom).offset(30)
                $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(40)
            }
            return
            
        case .register:
            self.addSubview(consentStack)
            
            consentStack.snp.makeConstraints {
                $0.top.equalTo(separateView.snp.bottom).offset(30)
                $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(30)
                $0.bottom.equalTo(signUpBtn.snp.top).offset(-30)
            }
            
            signUpBtn.snp.makeConstraints {
                $0.top.equalTo(consentStack.snp.bottom).offset(30)
                $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(40)
            }
        }
    }
}
