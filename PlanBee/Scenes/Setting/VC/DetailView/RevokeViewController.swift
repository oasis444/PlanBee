//
//  RevokeViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

class RevokeViewController: UIViewController {
    
    let viewModel = RevokeViewModel()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = viewModel.warningLabelFont
        label.textColor = viewModel.warningLabelColor
        label.textAlignment = .left
        label.text = viewModel.warningText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var revokeBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("탈퇴하기", for: .normal)
        button.titleLabel?.font = viewModel.revokeBtnFont
        button.setTitleColor(viewModel.revokeBtnTitleColor, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = viewModel.revokeBtnCornerRadius
        button.addTarget(self, action: #selector(didTappedRevokeBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = viewModel.indicoatorColor
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    deinit {
        print("deinit - RevokeVC")
    }
}

private extension RevokeViewController {
    func configure() {
        view.backgroundColor = ThemeColor.PlanBeeBackgroundColor
        
        configureLayout()
    }
    
    func configureLayout() {
        [warningLabel, revokeBtn, indicator].forEach {
            view.addSubview($0)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(viewModel.warningLabelLeadTrailInset)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(viewModel.warningLabelTopInset)
        }
        
        revokeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(viewModel.revokeBtnWidth)
            $0.centerY.equalToSuperview().offset(viewModel.revokeBtnCenterOffset)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func didTappedRevokeBtn() {
        reAuthenticateAlert()
    }
    
    func reAuthenticateAlert() {
        let alert = UIAlertController(title: "사용자 인증이 필요합니다",
                                      message: "탈퇴 처리를 하기 위해 로그인을 하여 사용자 인증을 해야 합니다.",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "사용자 인증", style: .destructive) { _ in
            let userPW = alert.textFields?[0].text ?? ""
            if userPW.count < 6 {
                self.viewModel.showAlert(view: self, title: "비밀번호 입력 오류", message: "비밀번호를 6자리 이상을 입력해 주세요")
                return
            }
            self.indicator.startAnimating()
            Task {
                if await FirebaseManager.shared.reAuthenticate(password: userPW) {
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.askRevokeAlert()
                        return
                    }
                }
                self.indicator.stopAnimating()
                self.viewModel.showAlert(view: self, title: "사용자 인증 실패", message: "사용자 인증에 실패하였습니다. 다시 인증해 주세요")
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addTextField {
            $0.placeholder = "비밀번호를 6자리 이상을 입력해 주세요"
            $0.keyboardType = .asciiCapable
            $0.isSecureTextEntry = true
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }
    
    func askRevokeAlert() {
        let alert = UIAlertController(title: "정말 탈퇴하시겠습니까?",
                                      message: "탈퇴하시면 사용자의 모든 정보가 삭제되고 복구할 수 없습니다.",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "탈퇴하기", style: .destructive) { _ in
            self.indicator.startAnimating()
            self.revokeBtn.isEnabled = false
            self.viewModel.removeAllInfo(view: self)
        }
        let cancel = UIAlertAction(title: "계정 유지", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
