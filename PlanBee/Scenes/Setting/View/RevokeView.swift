//
//  RevokeView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class RevokeView: UIView {
    private lazy var warningLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: """
                    탈퇴를 하면 계정 삭제 및
                    사용자의 정보가 모두 삭제가 됩니다.
                    """,
            font: ThemeFont.bold(size: 30),
            textColor: .systemPink,
            textAlignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var revokeBtn: UIButton = {
        let button = ButtonFactory.makeButton(
            title: "탈퇴하기",
            titleLabelFont: ThemeFont.bold(size: 30),
            titleColor: .systemPink,
            backgroundColor: .label,
            cornerRadius: 10)
        return button
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = ThemeColor.indicatorColor
        return indicator
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RevokeView {
    func setLayout() {
        [warningLabel, revokeBtn, indicator].forEach {
            self.addSubview($0)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(50)
        }
        
        revokeBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.centerY.equalToSuperview().offset(100)
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
