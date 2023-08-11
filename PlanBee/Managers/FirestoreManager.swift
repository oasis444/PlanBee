//
//  FirestoreManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirestoreManager {
    static let shared = FirestoreManager()
    private init() { }
    
    private let userDB = Firestore.firestore().collection("User")
    private let revokeUserDB = Firestore.firestore().collection("RevokeUser")
    
    func saveTodo(data: Todo) async {
        guard let uid = FirebaseManager.shared.getUID() else { return }
        
        var retryCount = 0
        while retryCount < 3 {
            do {
                try await userDB.document(uid)
                    .collection(data.date).document(data.id.uuidString).setData(
                        [
                            "id": data.id.uuidString,
                            "content": data.content,
                            "date": data.date,
                            "priority": data.priority,
                            "done": data.done,
                            "alarm": data.alarm ?? "nil"
                        ]
                    )
                print("Document successfully added!")
                return
            } catch {
                print("Error adding document: \(error.localizedDescription)")
                retryCount += 1
            }
        }
        print("Max retry count reached, document could not be added.")
    }
    
    func deleteTodo(data: Todo) async {
        guard let uid = FirebaseManager.shared.getUID() else { return }
        
        var retryCount = 0
        while retryCount < 3 {
            do {
                try await userDB.document(uid)
                    .collection(data.date).document(data.id.uuidString).delete()
                print("Document successfully removed!")
                return
            } catch {
                print("Error removing document: \(error.localizedDescription)")
                retryCount += 1
            }
        }
        print("Max retry count reached, document could not be removed.")
    }
    
    // 우선순위, 완료, 알림 수정 가능
    func updateTodo(data: Todo) async {
        guard let uid = FirebaseManager.shared.getUID() else { return }
        
        var retryCount = 0
        while retryCount < 3 {
            do {
                try await userDB.document(uid)
                    .collection(data.date).document(data.id.uuidString).updateData(
                        [
                            "priority": data.priority,
                            "done": data.done,
                            "alarm": data.alarm ?? "nil"
                        ]
                    )
                print("Document successfully updated!")
                return
            } catch {
                print("Error updating document: \(error.localizedDescription)")
                retryCount += 1
            }
        }
        print("Max retry count reached, document could not be updated.")
    }
}

extension FirestoreManager {
    func getDocument(dateStr: String) async -> [Todo]? {
        guard let uid = FirebaseManager.shared.getUID() else { return nil }
        var todoList: [Todo] = []
        
        do {
            let snap = try await userDB.document(uid).collection("20230811").getDocuments()
            snap.documents.map { doc in
                doc.data()
            }.forEach {
                guard let id = $0["id"] as? UUID,
                      let content = $0["content"] as? String,
                      let date = $0["date"] as? String,
                      let priority = $0["priority"] as? Date,
                      let done = $0["done"] as? Bool,
                      let alarm = $0["alarm"] as? Date else { return }
                
                let todo = Todo(id: id,
                                content: content,
                                date: date,
                                priority: priority,
                                done: done,
                                alarm: alarm)
                todoList.append(todo)
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
//        userDB.document(uid).collection("20230811").getDocuments { snap, error in
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//                return
//            }
//            guard let snap = snap else { return }
//            snap.documents.map { doc in
//                doc.data()
//            }.forEach {
//                guard let id = $0["id"] as? UUID,
//                      let content = $0["content"] as? String,
//                      let date = $0["date"] as? String,
//                      let priority = $0["priority"] as? Date,
//                      let done = $0["done"] as? Bool,
//                      let alarm = $0["alarm"] as? Date else { return }
//
//                let todo = Todo(id: id,
//                                content: content,
//                                date: date,
//                                priority: priority,
//                                done: done,
//                                alarm: alarm)
//                todoList.append(todo)
//            }
//        }
        return todoList
    }
}

extension FirestoreManager {
    func saveRevokeUser() async {
        guard let uid = FirebaseManager.shared.getUID() else { return }
        
        var retryCount = 0
        while retryCount < 3 {
            do {
                try await revokeUserDB.document(uid)
                    .setData(
                        ["revokeUser": uid]
                    )
                print("Document successfully added!")
                return
            } catch {
                print("Error adding document: \(error.localizedDescription)")
                retryCount += 1
            }
        }
        print("Max retry count reached, document could not be added.")
    }
}
