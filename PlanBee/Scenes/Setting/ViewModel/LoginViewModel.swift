//
//  LoginViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine

enum LoginBtnType {
    case login
    case register
}

final class LoginViewModel {
    
    @Published var email: String = ""
    @Published var password: String = ""
    var viewType: LoginBtnType = .login
    var textFieldIsFill: Bool = false
    var checkBoxFill: Bool = false
    let isReturnUser = "isReturnUser"
    private let emailChecker = EmailValidCheck()
    
    let indicatorColor: UIColor = .systemOrange
    let emailTextFieldPlaceholder = "이메일 입력"
    let textFieldStyle: UITextField.BorderStyle = .roundedRect
    let textFieldColor: UIColor = .label
    let textFieldFont: UIFont = .systemFont(ofSize: 22, weight: .regular)
    let emailTextFieldKeyboardType: UIKeyboardType = .emailAddress
    
    let passwordTextFieldPlaceholder = "비밀번호 입력"
    let passwordTextFieldKeyboardType: UIKeyboardType = .asciiCapable
    
    let textFieldStackSpacing: CGFloat = 10
    
    let separateViewColor: UIColor = .label
    let separateViewHeight: CGFloat = 2
    
    let ageCheckBoxImage: UIImage = UIImage(systemName: "checkmark.square") ?? UIImage()
    let ageCheckBoxColor: UIColor = .lightGray
    let ageCheckBoxTag = 0
    let ageCheckBoxInset: CGFloat = 4
    let ageCheckBoxWidth: CGFloat = 40
    
    let ageCheckLabelFont: UIFont = .systemFont(ofSize: 22, weight: .bold)
    let ageCheckLabelText = "만 14세 이상입니다."
    let ageCheckLabelColor: UIColor = .label
    
    let ageCheckStackSpacing: CGFloat = 20
    
    let personalInfoCheckBoxImage: UIImage = UIImage(systemName: "checkmark.square") ?? UIImage()
    let personalInfoCheckBoxColor: UIColor = .lightGray
    let personalInfoCheckBoxInset: CGFloat = 4
    let personalInfoCheckBoxTag = 0
    let personalInfoCheckBoxWidth: CGFloat = 40
    
    let personalInfoLabelTitle = "개인정보 수집 이용 및 동의서"
    let personalInfoLabelFont: UIFont = .systemFont(ofSize: 22, weight: .bold)
    let personalInfoLabelColor: UIColor = .systemPink
    
    let signUpButtonFont: UIFont = .systemFont(ofSize: 25, weight: .bold)
    var signUpButtonTitle: String {
        switch viewType {
        case .login: return "로그인"
        case .register: return "회원가입"
        }
    }
    let signUpButtonBackgroundColor: UIColor = .lightGray
    let signUpButtonTintColor: UIColor = .white
    let signUpButtonRadius: CGFloat = 10
    let signUpBtnPadding: CGFloat = 30
    let signUpBtnLeadTrailInset: CGFloat = 40
    
    let personalInfoStackSpacing: CGFloat = 20

    let consentStackSpacing: CGFloat = 20
    
    let defaultInset: CGFloat = 16
    let dismissBtnWidth: CGFloat = 40
    let textFieldStackViewTopOffset: CGFloat = 50
    let textFieldStackViewLeadTrailOffset: CGFloat = 50
    
    let separateViewPadding: CGFloat = 30
    let separateViewLeadTrailOffset: CGFloat = 50
    
    let consentStackLeadTrailOffset: CGFloat = 30
    
    func buttonON(button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = .systemIndigo
    }
    
    func buttonOFF(button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .lightGray
    }
    
    lazy var textFieldInputChecker: AnyPublisher<Bool, Never> = Publishers.CombineLatest($email, $password)
        .map { [weak self] email, password in
            guard let self = self else { return false }
            let emailCheckResult = self.emailChecking(email: email)
            let passwordCheckResult = self.passwordChecking(password: password)
            
            if emailCheckResult && passwordCheckResult {
                return true
            }
            return false
        }
        .eraseToAnyPublisher()
    
    func checkReturnUser(view: UIViewController) -> Bool {
        // 이전에 로그인 한 기록이 없다면 ReturnUser == true
        if let isReturnUser: Bool = UserDefaultsManager.shared.getValue(forKey: isReturnUser) {
            if isReturnUser { return true }
            return false
        } else {
            return true
        }
    }
    
    func showAlert(view: UIViewController, title: String, error: FirebaseErrors) {
        let alert = UIAlertController(title: title, message: error.errorMessage, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        view.present(alert, animated: true)
    }
}

private extension LoginViewModel {
    func emailChecking(email: String) -> Bool {
        return emailChecker.isValidEmail(email: email)
    }
    
    func passwordChecking(password: String) -> Bool {
        if password.count >= 6 {
            return true
        } else {
            return false
        }
    }
}
