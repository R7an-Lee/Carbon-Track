//
//  Tip.swift
//  CT
//
//  Created by Yuxuan Li on 4/3/23.
//

import Foundation
import CoreData

// ❎ Core Data Company entity public class
public class Tip: NSManagedObject, Identifiable {
    
    @NSManaged public var id: NSNumber?
    @NSManaged public var title: String?
    @NSManaged public var tipsPhotoFilename: String?
    @NSManaged public var tipsContent: String?
}
extension Tip{
    /*
     ❎ CoreData @FetchRequest in FavoritesList.swift invokes this class method
        to fetch all of the Company entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Company.allCompaniesFetchRequest() in any .swift file in your project.
     */
    static func allTipsFetchRequest() -> NSFetchRequest<Tip> {
        /*
         Create a fetchRequest to fetch Cities entities from the database.
         Since the fetchRequest's 'predicate' property is not set to filter,
         all of the Company entities will be fetched.
         */
        let fetchRequest = NSFetchRequest<Tip>(entityName: "Tip")

        fetchRequest.sortDescriptors = [
            // List the fetched Company entities in ascending order with respect to orderNumber
            NSSortDescriptor(key: "id", ascending: true)
        ]
        
        return fetchRequest
    }
}
