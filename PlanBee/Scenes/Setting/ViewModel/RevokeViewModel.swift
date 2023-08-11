//
//  RevokeViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class RevokeViewModel {
    let warningText = """
                    탈퇴를 하면 계정 삭제 및
                    사용자의 정보가 모두 삭제가 됩니다.
                    """
    
    let warningLabelFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    let warningLabelColor: UIColor = .systemPink
    
    let revokeBtnFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    let revokeBtnTitleColor: UIColor = .systemPink
    let revokeBtnCornerRadius: CGFloat = 10
    
    let indicoatorColor: UIColor = .systemOrange
    
    let warningLabelLeadTrailInset: CGFloat = 30
    let warningLabelTopInset: CGFloat = 50
    
    let revokeBtnWidth: CGFloat = 180
    let revokeBtnCenterOffset: CGFloat = 100
    
    func showAlert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        view.present(alert, animated: true)
    }
    
    /// 주의!!! 모든 정보 삭제하기
    func removeAllInfo(view: UIViewController) {
        UserDefaultsManager.shared.removeAllUserDefauls()
        CoreDataManager.shared.removeAllPlanData()
        Task {
            await FirestoreManager.shared.saveRevokeUser()
            if await FirebaseManager.shared.removeUser() {
                revokeDoneAlert(view: view)
            }
        }
    }
}

private extension RevokeViewModel {
    /// 주의!!! 탈퇴 완료 Alert
    func revokeDoneAlert(view: UIViewController) {
        let alert = UIAlertController(title: "탈퇴 완료",
                                      message: "PlanBee를 종료합니다.",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            self.closeApp()
        }
        alert.addAction(confirm)
        view.present(alert, animated: true)
    }
    
    /// 주의!!! 자연스럽게 앱 종료하기
    func closeApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
