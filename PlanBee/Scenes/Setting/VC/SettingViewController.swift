//
//  SettingViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit

final class SettingViewController: UIViewController {
    
    private let viewModel = SettingViewModel()
    private let firebaseManager = FirebaseManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .PlanBeeBackgroundColor
        tableView.register(SettingProfileCell.self, forCellReuseIdentifier: SettingProfileCell.getIdentifier)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.getIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingView()
        configLayout()
                
        self.view.window?.overrideUserInterfaceStyle = .dark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadSections(IndexSet([0]), with: .automatic)
    }
}

private extension SettingViewController {
    func configureSettingView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.settingViewNavigationTitle
    }
    
    func configLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showAlert1(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func showAlert(loginState: Bool) {
        var alert = UIAlertController()
        if loginState {
            alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            let logOut = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                if let error = self.firebaseManager.logOut() {
                    print(error)
                    showAlert1(title: "로그아웃 실패", message: "나중에 다시 로그아웃 해주세요")
                    return
                }
                tableView.reloadSections(IndexSet([0]), with: .automatic)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(logOut)
            alert.addAction(cancel)
        } else {
            alert = UIAlertController(title: nil, message: "현재 로그아웃 상태입니다.", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirm)
        }
        present(alert, animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return SettingSection.profile.title
        case 1:
            return SettingSection.setting.title
        case 2:
            return SettingSection.infomation.title
        case 3:
            return SettingSection.etc.title
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return SettingSection.profile.items.count
        case 1:
            return SettingSection.setting.items.count
        case 2:
            return SettingSection.infomation.items.count
        case 3:
            return SettingSection.etc.items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(
            withIdentifier: SettingProfileCell.getIdentifier,
            for: indexPath) as? SettingProfileCell else { return UITableViewCell() }
        
        guard let defaultCell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.getIdentifier,
            for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            profileCell.configure()
            return profileCell
        case 1:
            defaultCell.configureCell(
                title: SettingSection.setting.items[indexPath.row],
                icon: SettingIcons.setting.iconImage[indexPath.row],
                iconColor: SettingIcons.setting.iconColor[indexPath.row])
            return defaultCell
        case 2:
            defaultCell.configureCell(
                title: SettingSection.infomation.items[indexPath.row],
                icon: SettingIcons.infomation.iconImage[indexPath.row],
                iconColor: SettingIcons.infomation.iconColor[indexPath.row])
            return defaultCell
        case 3:
            defaultCell.configureCell(
                title: SettingSection.etc.items[indexPath.row],
                icon: SettingIcons.etc.iconImage[indexPath.row],
                iconColor: SettingIcons.etc.iconColor[indexPath.row])
            return defaultCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if firebaseManager.checkLoginState() == true {
                
                return
            }
            let profileVC = SignInViewController()
            navigationController?.pushViewController(profileVC, animated: true)
            
        case 1:
            return
        case 2:
            return
        case 3:
            let loginState = firebaseManager.checkLoginState()
            showAlert(loginState: loginState)
            return
            
        default:
            return
        }
    }
}
