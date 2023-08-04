//
//  FirestoreManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

enum StoreError: String, Error {
    case noUID = "UID 없음"
    case saveError = "Todo 저장 실패"
    case deleteError = "Todo 삭제 실패"
}

final class FirestoreManager {
    private let fireManager = FirebaseManager()
    private let dataBase = Firestore.firestore().collection("User")
    
    func saveTodo(data: Todo) -> Bool? {
        guard let uid = fireManager.getUID() else { return false }
        dataBase.document(uid)
            .collection(data.date).document(data.id.uuidString).setData(
                [
                    "id": data.id.uuidString,
                    "content": data.content,
                    "date": data.date,
                    "priority": data.priority,
                    "done": data.done,
                    "alarm": data.alarm ?? "nil"
                ]
            ) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document successfully added!")
                }
            }
        return nil
    }
    
    func deleteTodo(data: Todo) -> StoreError? {
        guard let uid = fireManager.getUID() else { return .noUID }
        dataBase.document(uid)
            .collection(data.date).document(data.id.uuidString).delete { error in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription)")
                    return
                } else {
                    print("Document successfully removed!")
                }
            }
        return nil
    }
    
    // 우선순위, 완료, 알림 수정 가능
    func updateTodo(data: Todo) -> StoreError? {
        guard let uid = fireManager.getUID() else { return .noUID }
        dataBase.document(uid)
            .collection(data.date).document(data.id.uuidString).updateData(
                [
                    "priority": data.priority,
                    "done": data.done,
                    "alarm": data.alarm ?? "nil"
                ]
            ) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                    return
                } else {
                    print("Document successfully updated!")
                }
            }
        return nil
    }
}
