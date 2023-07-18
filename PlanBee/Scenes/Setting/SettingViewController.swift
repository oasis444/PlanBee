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
            return SettingSection.setting.title
        case 1:
            return SettingSection.infomation.title
        case 2:
            return SettingSection.etc.title
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return SettingSection.setting.items.count
        case 1:
            return SettingSection.infomation.items.count
        case 2:
            return SettingSection.etc.items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.getIdentifier,
            for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            cell.configureCell(
                title: SettingSection.setting.items[indexPath.row],
                icon: SettingIcons.setting.iconImage[indexPath.row],
                iconColor: SettingIcons.setting.iconColor[indexPath.row])
        case 1:
            cell.configureCell(
                title: SettingSection.infomation.items[indexPath.row],
                icon: SettingIcons.infomation.iconImage[indexPath.row],
                iconColor: SettingIcons.infomation.iconColor[indexPath.row])
        case 2:
            cell.configureCell(
                title: SettingSection.etc.items[indexPath.row],
                icon: SettingIcons.etc.iconImage[indexPath.row],
                iconColor: SettingIcons.etc.iconColor[indexPath.row])
        default:
            return UITableViewCell()
        }
        return cell
    }
}
