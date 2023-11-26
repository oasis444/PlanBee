//
//  VersionView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SnapKit
import UIKit

final class VersionView: UIView {
    private lazy var versionLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
            font: ThemeFont.bold(size: 20))
        label.numberOfLines = 1
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = ThemeColor.PlanBeeBackgroundColor
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension VersionView {
    func setLayout() {
        self.addSubview(versionLabel)
        
        versionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
