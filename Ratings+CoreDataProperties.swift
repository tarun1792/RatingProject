//
//  Ratings+CoreDataProperties.swift
//  Rating Assignment
//
//  Created by Tarun Kaushik on 18/04/20.
//  Copyright © 2020 Tarun Kaushik. All rights reserved.
//
//

import Foundation
import CoreData


extension Ratings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ratings> {
        return NSFetchRequest<Ratings>(entityName: "Ratings")
    }

    @NSManaged public var date: Date?
    @NSManaged public var lowerRating: Int32
    @NSManaged public var upperRating: Int32

}
