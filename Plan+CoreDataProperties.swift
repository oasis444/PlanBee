//
//  Plan+CoreDataProperties.swift
//  
//
//  Copyright (c) 2023 z-wook. All right reserved.
//
//

import Foundation
import CoreData

extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var done: Bool
    @NSManaged public var priority: Date?
    @NSManaged public var uuid: UUID?
    @NSManaged public var alarm: Date?

}
