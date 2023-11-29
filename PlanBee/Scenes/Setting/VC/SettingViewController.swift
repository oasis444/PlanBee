//
//  SettingViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SafariServices
import UIKit

final class SettingViewController: UIViewController {
    private let settingView = SettingView()
    private let viewModel = SettingViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingView.tableView.reloadSections(IndexSet([0]), with: .automatic)
    }
}

private extension SettingViewController {
    func configure() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
    }
    
    func showDefaultAlert(title: String, message: String) {
        let alert = AlertFactory.makeAlert(
            title: title,
            message: message,
            firstActionTitle: "확인")
        present(alert, animated: true)
    }
    
    func showLogOutAlert(loginState: Bool) {
        var alert: UIAlertController
        if loginState {
            alert = AlertFactory.makeAlert(
                title: "로그아웃",
                message: "로그아웃 하시겠습니까?",
                firstActionTitle: "로그아웃",
                firstActionStyle: .destructive,
                firstActionCompletion: { [weak self] in
                    guard let self = self else { return }
                    if viewModel.logout() {
                        settingView.tableView.reloadSections(IndexSet([0]), with: .automatic)
                        return
                    }
                    showDefaultAlert(title: "로그아웃 실패", message: "나중에 다시 로그아웃 해주세요")
                },
                secondActionTitle: "취소")
        } else {
            alert = AlertFactory.makeAlert(
                title: nil,
                message: "현재 로그아웃 상태입니다.",
                firstActionTitle: "확인")
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
        let index = indexPath.row
        
        switch indexPath.section {
        case 0:
            profileCell.profileNickNameLabel.text = FirebaseManager.shared.getUserEmail
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
                title: SettingSection.setting.items[index],
                iconImage: SettingIcons.setting.iconImage[index],
                iconColor: SettingIcons.setting.iconColor[index],
                screenMode: screedModeTitle)
        case 2:
            settingCell.configureCell(
                title: SettingSection.infomation.items[index],
                iconImage: SettingIcons.infomation.iconImage[index],
                iconColor: SettingIcons.infomation.iconColor[index])
        case 3:
            settingCell.configureCell(
                title: SettingSection.etc.items[index],
                iconImage: SettingIcons.etc.iconImage[index],
                iconColor: SettingIcons.etc.iconColor[index])
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
            case 1:
                if let url = URL(string: PRIVACY) {
                    let privacyVC = SFSafariViewController(url: url)
                    present(privacyVC, animated: true)
                }
            case 2:
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            case 3:
                let askVC = AskViewController()
                navigationController?.pushViewController(askVC, animated: true)
            default: return
            }
            
        case 3:
            switch indexPath.row {
            default:
                let loginState = FirebaseManager.shared.checkLoginState()
                showLogOutAlert(loginState: loginState)
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
            view.window?.overrideUserInterfaceStyle = .unspecified
            viewModel.saveScreenMode(mode: .unspecified)
            settingView.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        let lightMode = UIAlertAction(title: "라이트 모드", style: .default) { [weak self] _ in
            guard let self = self else { return }
            view.window?.overrideUserInterfaceStyle = .light
            viewModel.saveScreenMode(mode: .light)
            settingView.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        let darkMode = UIAlertAction(title: "다크 모드", style: .default) { [weak self] _ in
            guard let self = self else { return }
            view.window?.overrideUserInterfaceStyle = .dark
            viewModel.saveScreenMode(mode: .dark)
            settingView.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        [systemMode, lightMode, darkMode, cancel].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
}
