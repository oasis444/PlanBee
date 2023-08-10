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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .PlanBeeBackgroundColor
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.getIdentifier)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.getIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingView()
        configLayout()
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
    
    func showDefaultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func showLogoutAlert(loginState: Bool) {
        var alert = UIAlertController()
        if loginState {
            alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            let logOut = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                if let error = FirebaseManager.shared.logOut() {
                    print(error)
                    showDefaultAlert(title: "로그아웃 실패", message: "나중에 다시 로그아웃 해주세요")
                    return
                }
                tableView.reloadSections(IndexSet([0]), with: .automatic)
            }
            let cancel = UIAlertAction(title: "취소", style: .default)
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
            return nil
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
            withIdentifier: ProfileCell.getIdentifier,
            for: indexPath) as? ProfileCell else { return UITableViewCell() }
        
        guard let settingCell = tableView.dequeueReusableCell(
            withIdentifier: SettingCell.getIdentifier,
            for: indexPath) as? SettingCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            profileCell.configure()
            return profileCell
        case 1:
            var screedModeTitle: String?
            
            switch indexPath.row {
            case 0:
                screedModeTitle = viewModel.subTitle(type: .screenMode)
            case 1:
                screedModeTitle = viewModel.subTitle(type: .alarm)
            default:
                return settingCell
            }
            settingCell.configureCell(
                title: SettingSection.setting.items[indexPath.row],
                iconImage: SettingIcons.setting.iconImage[indexPath.row],
                iconColor: SettingIcons.setting.iconColor[indexPath.row],
                screenMode: screedModeTitle)
        case 2:
            settingCell.configureCell(
                title: SettingSection.infomation.items[indexPath.row],
                iconImage: SettingIcons.infomation.iconImage[indexPath.row],
                iconColor: SettingIcons.infomation.iconColor[indexPath.row])
        case 3:
            settingCell.configureCell(
                title: SettingSection.etc.items[indexPath.row],
                iconImage: SettingIcons.etc.iconImage[indexPath.row],
                iconColor: SettingIcons.etc.iconColor[indexPath.row])
        default:
            return UITableViewCell()
        }
        return settingCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if FirebaseManager.shared.checkLoginState() == true {
                let profileVC = ProfileViewController()
                navigationController?.pushViewController(profileVC, animated: true)
                return
            }
            let signInVC = SignInViewController()
            navigationController?.pushViewController(signInVC, animated: true)
            
        case 1:
            let cellTitle = SettingSection.setting.items[indexPath.row]
            switch cellTitle {
            case SettingSection.Setting.screenMode.title:
                showScreenMode()
            case SettingSection.Setting.alarm.title:
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            default: return
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                let versionVC = VersionViewController()
                navigationController?.pushViewController(versionVC, animated: true)
            case 1: return
            default: return
            }
            
        case 3:
            switch indexPath.row {
            default:
                let loginState = FirebaseManager.shared.checkLoginState()
                showLogoutAlert(loginState: loginState)
            }
            
        default: return
        }
    }
}

private extension SettingViewController {
    func showScreenMode() {
        let alert = UIAlertController(title: "화면 모드", message: nil, preferredStyle: .actionSheet)
        let systemMode = UIAlertAction(title: "시스템 기본값", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.saveScreenMode(viewController: self, mode: .unspecified)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        let lightMode = UIAlertAction(title: "라이트 모드", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.saveScreenMode(viewController: self, mode: .light)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        let darkMode = UIAlertAction(title: "다크 모드", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.saveScreenMode(viewController: self, mode: .dark)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        [systemMode, lightMode, darkMode, cancel].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
}
