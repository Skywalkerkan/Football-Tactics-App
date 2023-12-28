//
//  Person+CoreDataProperties.swift
//  Football Tactics App
//
//  Created by Erkan on 28.12.2023.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var shooting: String?
    @NSManaged public var image: Data?
    @NSManaged public var dribbling: String?
    @NSManaged public var pace: String?
    @NSManaged public var physical: String?
    @NSManaged public var passing: String?
    @NSManaged public var defending: String?

}

extension Person : Identifiable {

}
