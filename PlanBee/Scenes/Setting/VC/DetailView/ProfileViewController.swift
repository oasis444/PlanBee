//
//  ProfileViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine
import SwiftUI

final class ProfileViewController: UIViewController {
    
    private let profileView = ProfileView()
    private let viewModel = ProfileViewModel()
    private let detailViewModel = ProfileDetailViewModel()
    private var didTapped: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    deinit {
        print("deinit - ProfileVC")
    }
}

private extension ProfileViewController {
    func configure() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = ThemeColor.PlanBeeBackgroundColor
        
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
    }
    
    func bind() {
        viewModel.sendEmailSubject.sink { [weak self] alertType in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.didTapped.toggle()
                self.profileView.indicator.stopAnimating()
                
                switch alertType {
                case .sendEmailSuccess:
                    self.showSendEmailAlert(email: self.viewModel.getUserEmail, type: .sendEmailSuccess)
                    
                case .sendEmailFail:
                    self.showSendEmailAlert(type: .sendEmailFail)
                }
            }
        }.store(in: &cancellable)
    }
    
    func showChangePWAlert() {
        let alert = AlertFactory.makeAlert(
            title: "비밀번호 변경",
            message: "비밀번호를 변경하시겠습니까?",
            firstActionTitle: "확인",
            firstActionStyle: .destructive,
            firstActionCompletion: { [weak self] in
                guard let self = self else { return }
                self.didTapped.toggle()
                self.profileView.indicator.startAnimating()
                viewModel.sendEmail
            },
            secondActionTitle: "취소")
        present(alert, animated: true)
    }
    
    func showSendEmailAlert(email: String? = nil, type: AlertType) {
        let title: String
        let message: String
        let actionTitle = "확인"
        var firstActionCompletion: (() -> Void)?
        
        switch type {
        case .sendEmailSuccess:
            guard let email = email else { return }
            title = "이메일 전송 완료"
            message = "비밀번호 변경을 위해 '\(email)'로 이메일이 전송되었습니다. 비밀번호 변경 후 다시 로그인해 주세요."
            firstActionCompletion = { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            
        case .sendEmailFail:
            title = "이메일 전송 실패"
            message = "이메일 전송에 실패했습니다. 잠시 후 다시 시도해 주세요."
        }
        
        let alert = AlertFactory.makeAlert(
            title: title,
            message: message,
            firstActionTitle: actionTitle,
            firstActionCompletion: firstActionCompletion)
        present(alert, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileDetailItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ProfileDetailItems.account.items.count
        case 1:
            return ProfileDetailItems.service.items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileDetailCell.getIdentifier,
            for: indexPath) as? ProfileDetailCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.configure(title: ProfileDetailItems.account.items[indexPath.row])
        case 1:
            cell.configure(title: ProfileDetailItems.service.items[indexPath.row])
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ProfileDetailItems.account.title
        case 1:
            return ProfileDetailItems.service.title
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let cellTitle = ProfileDetailItems.account.items[indexPath.row]
            switch cellTitle {
            case ProfileDetailItems.Account.password.title:
                if didTapped == false {
                    showChangePWAlert()
                }
            default: return
            }
            
        case 1:
            let cellTitle = ProfileDetailItems.service.items[indexPath.row]
            switch cellTitle {
            case ProfileDetailItems.Service.revoke.title:
                let revokeVC = RevokeViewController()
                navigationController?.pushViewController(revokeVC, animated: true)
            default: return
            }
            
        default: return
        }
    }
}

struct ProfileVCPreView: PreviewProvider {
    static var previews: some View {
        let profileVC = ProfileViewController()
        UINavigationController(rootViewController: profileVC)
            .toPreview().edgesIgnoringSafeArea(.all)
    }
}
