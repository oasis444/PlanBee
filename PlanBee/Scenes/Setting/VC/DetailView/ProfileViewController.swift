//
//  ProfileViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import Alamofire

final class ProfileViewController: UIViewController {
    
    fileprivate var currentNonce: String?
    
    private lazy var withdrawalBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("탈퇴하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(didTappedWithdrawalBtn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

private extension ProfileViewController {
    func configure() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .PlanBeeBackgroundColor
        
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(withdrawalBtn)
        
        withdrawalBtn.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    @objc func didTappedWithdrawalBtn() {
        print("didTapped")
        removeAccount()
    }
    
    func removeAccount() {
        let token = UserDefaults.standard.string(forKey: "refreshToken")
        
        if let token = token {
            
            let url = URL(string: "https://YOUR-URL.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard data != nil else { return }
            }
            print("-------> here")
            task.resume()
            
        }
    }
}
