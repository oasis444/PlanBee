//
//  ProfileViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    private let detailViewModel = ProfileDetailViewModel()
    private var didTapped: Bool = false
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.hidesWhenStopped = true
        indicatorView.color = viewModel.indicatorColor
        return indicatorView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileDetailCell.self, forCellReuseIdentifier: ProfileDetailCell.getIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    deinit {
        print("deinit - ProfileVC")
    }
}

private extension ProfileViewController {
    func configure() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .PlanBeeBackgroundColor
        
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.addSubview(indicator)
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func didTappedWithdrawalBtn() {
        print("didTapped")
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
                    showAlert()
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

extension ProfileViewController {
    func showAlert() {
        let alert = UIAlertController(title: "비밀번호 변경",
                                      message: "비밀번호를 변경하시겠습니까?",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.didTapped.toggle()
            self.indicator.startAnimating()
            Task {
                let sendEmailResult = await FirebaseManager.shared.sendEmailForChangePW()
                if sendEmailResult {
                    self.viewModel.showAlert(view: self,
                                             email: FirebaseManager.shared.getUserEmail(),
                                             type: AlertType.sendEmailSuccess)
                    _ = FirebaseManager.shared.logOut()
                    return
                }
                self.indicator.stopAnimating()
                self.viewModel.showAlert(view: self, type: AlertType.sendEmailFail)
                self.didTapped.toggle()
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
