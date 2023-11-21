//
//  AskView.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SnapKit
import UIKit

final class AskView: UIView {
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: "제목",
            font: ThemeFont.regular(size: 14),
            textAlignment: .left)
        label.textAlignment = .left
        return label
    }()

    lazy var titleTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "제목을 입력하세요"
        textfield.font = ThemeFont.regular(size: 14)
        textfield.borderStyle = .none
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textfield.leftViewMode = .always
        textfield.layer.borderColor = UIColor.darkGray.cgColor
        textfield.layer.borderWidth = 2
        textfield.layer.cornerRadius = 5
        return textfield
    }()
    
    private lazy var emptyView1: UIView = {
        return makeEmptyView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = LabelFactory.makeLabel(
            text: "문의내용",
            font: ThemeFont.regular(size: 14),
            textAlignment: .left)
        label.textAlignment = .left
        return label
    }()
    
    lazy var descriptionsTextView: UITextView = {
        let view = UITextView()
        view.font = ThemeFont.regular(size: 14)
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
        view.backgroundColor = ThemeColor.PlanBeeBackgroundColor
        return view
    }()
    
    private lazy var emptyView2: UIView = {
        return makeEmptyView
    }()
    
    private lazy var contactLabel: UILabel = {
        LabelFactory.makeLabel(
            text: "연락처 문의: jiwook.han.dev@gmail.com",
            font: ThemeFont.regular(size: 17),
            textColor: .systemGray)
    }()
    
    lazy var askButton: UIButton = {
        ButtonFactory.makeButton(
            title: "문의하기",
            titleLabelFont: ThemeFont.demibold(size: 25),
            titleColor: .black,
            backgroundColor: .systemYellow,
            cornerRadius: AppConstraint.defaultCornerRadius)
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        
        [titleLabel, titleTextField, emptyView1, contentLabel,
         descriptionsTextView, emptyView2, contactLabel, askButton].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
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

private extension AskView {
    func setLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(vStack)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints {
            $0.height.equalTo(35)
        }
        
        emptyView1.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        descriptionsTextView.snp.makeConstraints {
            $0.height.equalTo(400)
        }
        
        emptyView2.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
    var makeEmptyView: UIView {
        return UIView()
    }
}
