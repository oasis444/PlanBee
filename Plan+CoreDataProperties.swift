//
//  Plan+CoreDataProperties.swift
//  
//
//  Copyright (c) 2023 oasis444. All right reserved.
//
//

import Foundation
import CoreData

extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var content: String?
    @NSManaged public var done: Bool

}
