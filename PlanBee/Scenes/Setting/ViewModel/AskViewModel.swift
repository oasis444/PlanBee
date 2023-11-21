//
//  AskViewModel.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class AskViewModel {
    private let firestoreManager = FirestoreManager.shared
}

extension AskViewModel {
    func sendAsk(title: String?, descriptions: String) {
        Task {
            let error = await firestoreManager.saveAsk(title: title ?? "", descriptions: descriptions)
            if let error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
