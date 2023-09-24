//
//  AlertFactory.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

struct AlertFactory {
    static func makeAlert(title: String?,
                          message: String?,
                          firstActionTitle: String?,
                          firstActionStyle: UIAlertAction.Style = .default,
                          firstActionCompletion: (() -> Void)? = nil,
                          secondActionTitle: String? = nil,
                          secondActionStyle: UIAlertAction.Style? = .default,
                          secondActioncompletion: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstActionTitle, style: firstActionStyle) { _ in
            firstActionCompletion?()
        }
        alertController.addAction(firstAction)
        
        if let secondActionTitle = secondActionTitle,
           let secondActionStyle = secondActionStyle {
            let secondAction = UIAlertAction(title: secondActionTitle, style: secondActionStyle) { _ in
                secondActioncompletion?()
            }
            alertController.addAction(secondAction)
        }
        return alertController
    }
}
