//
//  SettingView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SnapKit
import UIKit

final class SettingView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = ThemeColor.PlanBeeBackgroundColor
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.getIdentifier)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.getIdentifier)
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingView {
    func setLayout() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
