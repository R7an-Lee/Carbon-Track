//
//  Climatiq.swift
//  CT
//
//  Created by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import Foundation
import CoreData

// ✳️ Core Data Climatiq Entity public class
public class Climatiq: NSManagedObject, Identifiable {

    // Attributes
    @NSManaged public var co2e: NSNumber?
    @NSManaged public var co2e_unit: String?
    @NSManaged public var name: String?
    @NSManaged public var activity_id: String?
    @NSManaged public var year: String?
    @NSManaged public var region: String?
    @NSManaged public var category: String?        
    
}

/*
 🔴 Swift type Integer cannot be used for @NSManaged Core Data attributes
 because the type Integer cannot be represented in Objective-C, which is
 internally used by Core Data.
 
 Therefore, we must use the Objective-C data type NSNumber instead.
 
 We convert NSNumber to Integer by typecasting with 'as'
    let integerValue = nsNumberValue as Integer
 
 We convert Integer to NSNumber with
    let nsNumberValue = integerValue as NSNumber or NSNumber(value: integerValue)
 */

extension Climatiq {
    /*
     ✳️ Core Data @FetchRequest in FavoritesList.swift invokes this class method
        to fetch all of the Climatiq entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Climatiq.allClimatiqFetchRequest() in any .swift file in your project.
     */
    static func allClimatiqFetchRequest() -> NSFetchRequest<Climatiq> {
        /*
         Create a fetchRequest to fetch Climatiq entities from the database.
         Since the fetchRequest's 'predicate' property is not set to filter,
         all of the Climatiq entities will be fetched.
         */
        let fetchRequest = NSFetchRequest<Climatiq>(entityName: "Climatiq")
        
        /*
         List the fetched climatiq items in ascending order with respect to co2e.
         */
        fetchRequest.sortDescriptors = [
            // List the fetched Climatiq entities in ascending order with respect to co2e
            NSSortDescriptor(key: "co2e", ascending: true)
        ]
        
        return fetchRequest
    }

}

