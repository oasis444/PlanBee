//
//  FirebaseErrors.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

enum FirebaseErrors: Int {
    case FIRAuthErrorCodeEmailAlreadyInUse = 17007
    case FIRAuthErrorCodeInvalidEmail = 17008
    case FIRAuthErrorCodeOperationNotAllowed
    case FIRAuthErrorCodeWeakPassword
    case FIRAuthErrorCodeRequiresRecentLogin
    case FIRAuthErrorCodeLeastPasswordLength = 17026
    case unknown = -99999
    
    var errorCode: Int { rawValue }
    
    var errorMessage: String {
        switch self {
        case .FIRAuthErrorCodeEmailAlreadyInUse:
            return "이미 사용 중인 이메일입니다."
            
        case .FIRAuthErrorCodeInvalidEmail:
            return "이메일 주소 형식이 잘못되었습니다."
            
        case .FIRAuthErrorCodeOperationNotAllowed:
            return "관리자가 계정을 사용 중지시켰습니다."
            
        case .FIRAuthErrorCodeWeakPassword:
            return "안전성이 낮은 비밀번호입니다."
            
        case .FIRAuthErrorCodeRequiresRecentLogin:
            return "최근에 로그인한 적이 있어야 진행할 수 있습니다."
            
        case .FIRAuthErrorCodeLeastPasswordLength:
            return "비밀번호는 6자리 이상이어야 합니다."
            
        case .unknown:
            return "알 수 없는 오류"
        }
    }
}
