//
//  TodoView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SnapKit
import UIKit

final class TodoView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ThemeColor.PlanBeeBackgroundColor
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.getIdentifier)
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

private extension TodoView {
    func setLayout() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
