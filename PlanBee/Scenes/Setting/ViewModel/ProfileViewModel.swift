//
//  ProfileViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

enum AlertType {
    case sendEmailSuccess
    case sendEmailFail
}

final class ProfileViewModel {
    
    let indicatorColor: UIColor = .systemOrange
    
    func showAlert(view: UIViewController, email: String? = nil, type: AlertType) {
        switch type {
        case .sendEmailSuccess:
            guard let email = email else { return }
            let alert = UIAlertController(title: "이메일 전송 완료",
                                          message: "비밀번호 변경을 위해 '\(email)'로 이메일이 전송되었습니다. 비밀번호 변경 후 다시 로그인해 주세요.",
                                          preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default) {_ in
                view.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(confirm)
            view.present(alert, animated: true)
            
        case .sendEmailFail:
            let alert = UIAlertController(title: "이메일 전송 실패",
                                          message: "이메일 전송에 실패했습니다. 잠시 후 다시 시도해 주세요.",
                                          preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirm)
            view.present(alert, animated: true)
        }
    }
}
