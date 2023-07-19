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
        tableView.register(SettingProfileCell.self, forCellReuseIdentifier: SettingProfileCell.getIdentifier)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.getIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingView()
        configLayout()
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
            if FirebaseManager().checkLoginState() == false {
                let profileVC = ProfileViewController()
                navigationController?.pushViewController(profileVC, animated: true)
            }
            return
        case 1:
            return
        case 2:
            return
        case 3:
            return
        default:
            return
        }
    }
}
