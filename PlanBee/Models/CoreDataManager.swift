//
//  CoreDataManager.swift
//  PlanBee
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    private static let planEntityName = "Plan"
    
    private static let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate가 초기화되지 않았습니다.")
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    static func saveTodoData(todo: Todo) {
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(
            forEntityName: planEntityName, in: context
        ) else { return }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(todo.id, forKey: Todokeys.uuid.key)
        object.setValue(todo.content, forKey: Todokeys.content.key)
        object.setValue(todo.date, forKey: Todokeys.date.key)
        object.setValue(todo.done, forKey: Todokeys.done.key)
        
        do {
            try context.save()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    static func fetchTodoData() {
        guard let context = context else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: planEntityName)
        
        do {
            guard let planList = try context.fetch(fetchRequest) as? [Plan] else { return }
            let todoList = planList.map {
                Todo(
                    id: $0.uuid ?? UUID(),
                    content: $0.content ?? "nil",
                    date: $0.date ?? Date.now,
                    done: $0.done
                )
            }
            print(todoList)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    static func updatePlanData(newTodo: Todo) -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: planEntityName)
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", newTodo.id.uuidString)
//        fetchRequest.predicate = NSPredicate(format: "uuid = %@", id as CVarArg)

        do {
            guard let result = try? context.fetch(fetchRequest),
                  let object = result.first as? NSManagedObject else { return false }
            object.setValue(newTodo.content, forKey: Todokeys.content.key)
            object.setValue(newTodo.date, forKey: Todokeys.date.key)
            object.setValue(newTodo.done, forKey: Todokeys.done.key)

            try context.save()
            return true
        } catch {
            print("error: \(error.localizedDescription)")
            return false
        }
    }
    
    static func deletePlanData(todo: Todo) -> Bool {
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
