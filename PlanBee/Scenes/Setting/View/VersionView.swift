//
//  VersionView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SnapKit
import UIKit

final class VersionView: UIView {
    private lazy var appIconImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "PlanBee"))
        return view
    }()
    
    private lazy var versionLabel: UILabel = {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "v1.0.0"
        let label = LabelFactory.makeLabel(
            text: "v" + version,
            font: ThemeFont.bold(size: 22))
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
        [appIconImageView, versionLabel].forEach {
            self.addSubview($0)
        }
        
        appIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(appIconImageView.snp.width)
        }
        
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
