//
//  ProfileViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine

enum AlertType {
    case sendEmailSuccess
    case sendEmailFail
}

final class ProfileViewModel {
    private let firebaseManger = FirebaseManager.shared
    let sendEmailSubject = PassthroughSubject<AlertType, Never>()
}

extension ProfileViewModel {
    var getUserEmail: String {
        return firebaseManger.getUserEmail()
    }
    
    var sendEmail: Void {
        Task {
            let sendEmailResult = await firebaseManger.sendEmailForChangePW()
            if sendEmailResult {
                logOut
                sendEmailSubject.send(.sendEmailSuccess)
                return
            }
            sendEmailSubject.send(.sendEmailFail)
        }
    }
    
    private var logOut: Void {
        _ = firebaseManger.logOut()
    }
}
