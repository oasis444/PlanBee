//
//  RevokeViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

class RevokeViewController: UIViewController {
    
    let warningText = """
                    탈퇴를 하면 계정 삭제 및
                    사용자의 정보가 모두 삭제가 됩니다.
                    """
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .systemPink
        label.textAlignment = .left
        label.text = warningText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var revokeBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("탈퇴하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.systemPink, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTappedRevokeBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemOrange
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
        view.backgroundColor = .PlanBeeBackgroundColor
        
        configureLayout()
    }
    
    func configureLayout() {
        [warningLabel, revokeBtn, indicator].forEach {
            view.addSubview($0)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        revokeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.centerY.equalToSuperview().offset(100)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func didTappedRevokeBtn() {
        // 탈퇴 전 로그인 인증
        let loginVC = LoginViewController()
        loginVC.configure(tapped: .login)
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .flipHorizontal
        present(loginVC, animated: true)
        
        // 로그인 후 돌아오면 completion으로 true 반환받고
        // 탈퇴 진행
        
//        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "정말 탈퇴하시겠습니까?",
                                      message: "탈퇴하시면 사용자의 모든 정보가 삭제되고 복구할 수 없습니다.",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "탈퇴하기", style: .destructive) { _ in
            self.indicator.startAnimating()
            self.revokeBtn.isEnabled = false
            self.removeAllInfo()
        }
        let cancel = UIAlertAction(title: "계정 유지", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func removeAllInfo() {
        CoreDataManager.shared.removeAllPlanData()
        Task {
            await FirestoreManager.shared.removeAllUserData()
            print("=======> ")
            if await FirebaseManager.shared.removeUser() {
                print("모든 삭제 완료")
                revokeDoneAlert()
            }
        }
    }
    
    private func revokeDoneAlert() {
        let alert = UIAlertController(title: "탈퇴 완료",
                                      message: "랭크핏을 종료합니다.",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            // 자연스럽게 앱 종료하기
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
        }
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }
}
