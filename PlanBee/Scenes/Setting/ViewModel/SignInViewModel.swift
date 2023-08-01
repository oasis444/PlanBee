//
//  SignInViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class SignInViewModel {
 
    let introLabelFont: UIFont = .systemFont(ofSize: 27, weight: .bold)
    let introLabelColor: UIColor = .label
    let introLabelText = """
        플랜비에 처음 오셨나요?
        
        회원 가입을 하면 언제 어디서든
        저장된 정보를 가져올 수 있습니다.
        """
    
    let loginBtnTitle = "로그인하기"
    let loginBtnFont: UIFont = .systemFont(ofSize: 22, weight: .medium)
    
    let registerBtnTitle = "회원가입하기"
    let registerBtnFont: UIFont = .systemFont(ofSize: 22, weight: .medium)
    
    let stackViewSpacing: CGFloat = 50
    
    let spacing: CGFloat = 24
}
