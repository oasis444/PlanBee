//
//  LoginViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import FirebaseAuth

enum LoginBtnType {
    case login
    case register
}

final class LoginViewController: UIViewController {
    
//    let email = "사용자 이메일 입력"
//    let pw = "이메일 비밀번호 입력"
//    
//    Auth.auth().createUser(withEmail: email, password: pw) { authResult, error in
//        if let error = error {
//            print("error: \(error.localizedDescription)")
//        }
//        guard let authResult = authResult else { return }
//        print("로그인 결과: \(authResult.user.uid)")
//    }
    
    private lazy var dismissBtn: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(didTappedDismissBtn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        
        
    }
    
//    let user = Auth.auth().currentUser
//    if let user = user {
//        print("현재 로그인된 유저 이메일: \(user.email)")
//    }
    
    func configure(tapped: LoginBtnType) {
        view.backgroundColor = .PlanBeeBackgroundColor
    }
    
    deinit {
        print("deint - LoginVC")
    }
}

private extension LoginViewController {
    
    
    func configureLayout() {
        [dismissBtn].forEach {
            view.addSubview($0)
        }
        
        dismissBtn.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(dismissBtn.snp.width)
            $0.width.equalTo(50)
        }
    }
    
    @objc func didTappedDismissBtn() {
        dismiss(animated: true)
    }
}
