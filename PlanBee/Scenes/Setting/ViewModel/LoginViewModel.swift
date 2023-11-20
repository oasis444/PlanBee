//
//  LoginViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Combine
import Foundation

final class LoginViewModel {
    private let firebaseManager = FirebaseManager.shared
    private let userDefaultManager = UserDefaultsManager.shared
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    let errorSubject = PassthroughSubject<(String, FirebaseErrors), Never>()
    
    private let emailChecker = EmailValidCheck()
    let viewType: LoginBtnType
    var textFieldIsFill: Bool = false
    var checkBoxFill: Bool = false
    let isReturnUser = "isReturnUser"
    
    init(loginButtonType: LoginBtnType) {
        self.viewType = loginButtonType
    }
    
    lazy var textFieldInputChecker = Publishers.CombineLatest3($email, $password, $passwordConfirm)
        .map { [weak self] email, password, passwordConfirm in
            guard let self = self else { return false }
            let emailCheckResult = self.emailChecking(email: email)
            let passwordCheckResult = self.passwordChecking(password: password, passwordConfirm: passwordConfirm)
            if emailCheckResult && passwordCheckResult {
                return true
            }
            return false
        }
        .eraseToAnyPublisher()
    
    var checkReturnUser: Bool {
        // 이전에 로그인 한 기록이 없다면 ReturnUser == true
        if let isReturnUser: Bool = userDefaultManager.getValue(forKey: isReturnUser) {
            if isReturnUser { return true }
            return false
        } else {
            return true
        }
    }
}

extension LoginViewModel {
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        firebaseLogin(email: email, password: password) { [weak self] firebaseError in
            guard let self = self else { return }
            if let error = firebaseError {
                errorSubject.send(("로그인 실패", error))
                return
            }
            if checkReturnUser {
                ReturnPlanBee().saveTodoForReturnUser
            }
            completion(true)
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
        firebaseCreateUser(email: email, password: password) { [weak self] firebaseError in
            guard let self = self else { return }
            if let error = firebaseError {
                errorSubject.send(("회원가입 실패", error))
                return
            }
            self.userDefaultManager.setValue(value: false, key: self.isReturnUser)
            completion(true)
        }
    }
}

private extension LoginViewModel {
    func emailChecking(email: String) -> Bool {
        return emailChecker.isValidEmail(email: email)
    }
    
    func passwordChecking(password: String, passwordConfirm: String) -> Bool {
        switch viewType {
        case .login:
            if password.count >= 6 {
                return true
            } else {
                return false
            }
        case .register:
            if password.count >= 6 && password == passwordConfirm {
                return true
            } else {
                return false
            }
        }
    }
    
    func firebaseLogin(email: String, password: String, completion: @escaping (FirebaseErrors?) -> Void) {
        firebaseManager.emailLogIn(email: email, password: password) { firebaseError in
            if let error = firebaseError {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func firebaseCreateUser(email: String, password: String, completion: @escaping (FirebaseErrors?) -> Void) {
        firebaseManager.createUsers(email: email, password: password) { firebaseError in
            if let error = firebaseError {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
