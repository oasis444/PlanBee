//
//  AskViewController.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import SnapKit
import UIKit

final class AskViewController: UIViewController {
    private let askView = AskView()
    private let viewModel = AskViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = askView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setTarget()
    }
    
    deinit {
        print("deinit - AskVC")
    }
}

private extension AskViewController {
    func configure() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setTarget() {
        askView.askButton.addTarget(
            self,
            action: #selector(didTappedAskBtn),
            for: .touchUpInside)
    }
    
    @objc func didTappedAskBtn() {
        guard let title = askView.titleTextField.text,
              let descriptions = askView.descriptionsTextView.text else { return }
        if title.isEmpty || descriptions.isEmpty {
            showAlert(title: "문의사항 미입력", message: "문의할 내용을 입력해 주세요.")
            return
        }
        viewModel.sendAsk(title: title, descriptions: descriptions)
        showAlert(title: "접수 완료", message: "문의가 접수되었습니다.") { [weak self] in
            guard let self else { return }
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String, firstAction: (() -> Void)? = nil) {
        let alert = AlertFactory.makeAlert(
            title: title,
            message: message,
            firstActionTitle: "확인",
            firstActionCompletion: {
                firstAction?()
            })
        present(alert, animated: true)
    }
}
