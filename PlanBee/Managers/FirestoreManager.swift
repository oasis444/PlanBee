//
//  FirestoreManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

final class FirestoreManager {
    static let shared = FirestoreManager()
    private init() { }
    
    private let userDB = Firestore.firestore().collection("Todo")
    private let revokeUserDB = Firestore.firestore().collection("RevokeUser")
}

extension FirestoreManager {
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
                try await userDB.document(uid).collection(data.date).document(data.id.uuidString).delete()
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
    func getTodoList(strDate: String) async -> [Todo]? {
        guard let uid = FirebaseManager.shared.getUID() else { return nil }
        
        do {
            let querySnapshot = try await userDB.document(uid).collection(strDate).getDocuments()
            let documentSnapshot = querySnapshot.documents
            
            let todoList = documentSnapshot.compactMap { document -> Todo? in
                guard
                    let id = document["id"] as? String,
                    let content = document["content"] as? String,
                    let date = document["date"] as? String,
                    let priority = (document["priority"] as? Timestamp)?.dateValue(),
                    let done = document["done"] as? Bool else { return nil }
                // 알람은 복귀 유저가 저장하지 않아도 되는 정보이므로 제외함
                
                let todo = Todo(
                    id: UUID(uuidString: id) ?? UUID(),
                    content: content,
                    date: date,
                    priority: priority,
                    done: done
                )
                return todo
            }
            return todoList
        } catch {
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
    
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
