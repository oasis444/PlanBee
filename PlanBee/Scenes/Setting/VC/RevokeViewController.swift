//
//  RevokeViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class RevokeViewController: UIViewController {
    private let revokeView = RevokeView()
    private let viewModel = RevokeViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = revokeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setButtonTarget()
    }
    
    deinit {
        print("deinit - RevokeVC")
    }
}

private extension RevokeViewController {
    func configure() {
        view.backgroundColor = ThemeColor.PlanBeeBackgroundColor
    }
    
    func setButtonTarget() {
        revokeView.revokeBtn.addTarget(
            self,
            action: #selector(didTappedRevokeBtn),
            for: .touchUpInside)
    }
    
    @objc func didTappedRevokeBtn() {
        reAuthenticateAlert()
    }
    
    func reAuthenticateAlert() {
        var alert = UIAlertController()
        alert = AlertFactory.makeAlert(
            title: "사용자 인증이 필요합니다",
            message: "탈퇴 처리를 하기 위해 로그인을 하여 사용자 인증을 해야 합니다.",
            firstActionTitle: "사용자 인증",
            firstActionStyle: .destructive,
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                let userPW = alert.textFields?[0].text ?? ""
                if userPW.count < 6 {
                    showAlert(title: "비밀번호 입력 오류", message: "비밀번호를 6자리 이상을 입력해 주세요")
                    return
                }
                self.revokeView.indicator.startAnimating()
                viewModel.reAuthenticate(password: userPW) { result in
                    self.revokeView.indicator.stopAnimating()
                    if result {
                        self.askRevokeAlert()
                        return
                    }
                    self.showAlert(title: "사용자 인증 실패", message: "사용자 인증에 실패하였습니다. 다시 인증해 주세요")
                }
            },
            secondActionTitle: "취소",
            secondActionStyle: .cancel,
            secondActioncompletion: { [weak self] in
                guard let self = self else { return }
                navigationController?.popToRootViewController(animated: true)
            })
        alert.addTextField {
            $0.placeholder = "비밀번호를 6자리 이상을 입력해 주세요"
            $0.keyboardType = .asciiCapable
            $0.isSecureTextEntry = true
        }
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = AlertFactory.makeAlert(
            title: title,
            message: message,
            firstActionTitle: "확인")
        present(alert, animated: true)
    }
    
    func askRevokeAlert() {
        let alert = AlertFactory.makeAlert(
            title: "정말 탈퇴하시겠습니까?",
            message: "탈퇴하시면 사용자의 모든 정보가 삭제되고 복구할 수 없습니다.",
            firstActionTitle: "탈퇴하기",
            firstActionStyle: .destructive,
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                revokeView.indicator.startAnimating()
                revokeView.revokeBtn.isEnabled = false
                viewModel.removeAllInfo {
                    self.revokeDoneAlert
                }
            },
            secondActionTitle: "계정 유지",
            secondActioncompletion: { [weak self] in
                guard let self = self else { return }
                navigationController?.popToRootViewController(animated: true)
            })
        self.present(alert, animated: true)
    }
}

private extension RevokeViewController {
    /// 주의!!! 탈퇴 완료 Alert
    var revokeDoneAlert: Void {
        let alert = AlertFactory.makeAlert(
            title: "탈퇴 완료",
            message: "PlanBee를 종료합니다.",
            firstActionTitle: "확인",
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                self.closeApp()
            })
        self.present(alert, animated: true)
    }
    
    /// 주의!!! 자연스럽게 앱 종료하기
    func closeApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
