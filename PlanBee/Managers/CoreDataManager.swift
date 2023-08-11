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
            print("여기 에러: \(error)")
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
