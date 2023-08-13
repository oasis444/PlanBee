//
//  CoreDataManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    private let planEntityName = "Plan"
    
    private let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate가 초기화되지 않았습니다.")
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func saveTodoData(todo: Todo) -> Bool {
        guard let context = context else { return false }
        guard let entity = NSEntityDescription.entity(
            forEntityName: planEntityName, in: context
        ) else { return false }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(todo.id, forKey: Todokeys.uuid.key)
        object.setValue(todo.content, forKey: Todokeys.content.key)
        object.setValue(todo.date, forKey: Todokeys.date.key)
        object.setValue(todo.priority, forKey: Todokeys.priority.key)
        object.setValue(todo.done, forKey: Todokeys.done.key)
        
        do {
            try context.save()
            return true
        } catch {
            print("error: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchTodoData(date: Date? = nil) -> [Todo]? {
        guard let context = context else { return nil }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: planEntityName)
        
        do {
            if let date = date {
                let strDate = DateFormatter.formatTodoDate(date: date)
                fetchRequest.predicate = NSPredicate(format: "date = %@", strDate)
                guard let planList = try context.fetch(fetchRequest) as? [Plan] else { return nil }
                let todoList = planList.map {
                    Todo(
                        id: $0.uuid ?? UUID(),
                        content: $0.content ?? "nil",
                        date: $0.date ?? strDate,
                        priority: $0.priority ?? Date(),
                        done: $0.done,
                        alarm: $0.alarm
                    )
                }
                return todoList
            }
            guard let planList = try context.fetch(fetchRequest) as? [Plan] else { return nil }
            let defaultDate = DateFormatter.formatTodoDate(date: Date())
            let todoList = planList.map {
                Todo(
                    id: $0.uuid ?? UUID(),
                    content: $0.content ?? "nil",
                    date: $0.date ?? defaultDate,
                    priority: $0.priority ?? Date(),
                    done: $0.done,
                    alarm: $0.alarm
                )
            }
            return todoList
        } catch {
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateTodoData(newTodo: Todo) -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: planEntityName)
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", newTodo.id.uuidString)
        
        do {
            guard let result = try? context.fetch(fetchRequest),
                  let object = result.first as? NSManagedObject else { return false }
            object.setValue(newTodo.content, forKey: Todokeys.content.key)
            object.setValue(newTodo.date, forKey: Todokeys.date.key)
            object.setValue(newTodo.priority, forKey: Todokeys.priority.key)
            object.setValue(newTodo.done, forKey: Todokeys.done.key)
            object.setValue(newTodo.alarm, forKey: Todokeys.alarm.key)
            
            try context.save()
            return true
        } catch {
            print("error: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteTodoData(todo: Todo) -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: planEntityName)
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", todo.id.uuidString)

        do {
            guard let result = try? context.fetch(fetchRequest),
                  let object = result.first as? NSManagedObject else { return false }
            context.delete(object)

            try context.save()
            return true
        } catch {
            print("error: \(error.localizedDescription)")
            return false
        }
    }
}

extension CoreDataManager {
    /// 복귀 유저의 데이터 저장을 위한 메서드
    func saveTodoDataAtOnce(todos: [Todo]) {
        guard let context = context else { return }
        let object = todos.compactMap { data -> [String: Any]? in
            let todo: [String: Any] = [
                Todokeys.uuid.key: data.id,
                Todokeys.content.key: data.content,
                Todokeys.date.key: data.date,
                Todokeys.priority.key: data.priority,
                Todokeys.done.key: data.done
            ]
            return todo
        }
        // NSBatchInsertRequest를 사용하면 대량의 데이터를 효율적으로 CoreData에 추가할 수 있습니다.
        // 단일 요청으로 여러 객체를 추가할 수 있으므로 성능 향상을 기대할 수 있습니다.
        let batchInsertRequest = NSBatchInsertRequest(entityName: planEntityName, objects: object)
        
        do {
            let result = try context.execute(batchInsertRequest) as? NSBatchInsertResult
            if let success = result?.result as? Bool, success {
                print("Batch insert successful")
                return
            }
        } catch {
            print("error: \(error.localizedDescription)")
            return
        }
    }
    
    func removeAllPlanData() {
        guard let context = context else { return }
        let entityNames: [String] = [planEntityName]
        
        for entity in entityNames {
            let fetrequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            // Batch는 한꺼번에 데이터처리를 할때 사용, 아래의 경우 저장된 데이터를 모두 지우는 것
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetrequest)
            do {
                try context.execute(deleteRequest)
                print("\(entity) 데이터 모두 삭제")
            } catch {
                print("삭제 중 오류 발생: \(error.localizedDescription)")
            }
        }
        return
    }
}
