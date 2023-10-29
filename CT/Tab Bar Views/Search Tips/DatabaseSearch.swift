//
//  DatabaseSearch.swift
//  Cities
//
//  Created by Yuxuan Li on 4/27/23.
//  Copyright © 2023 Yuxuan Li. All rights reserved.
//  Data base search functions
//

import SwiftUI
import CoreData

// Global variable
var databaseSearchResults = [Tip]()

// Global Search Parameters
var searchCategory = ""
var searchQuery = ""

fileprivate let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.persistentContainer.viewContext

/*
 =====================
 MARK: Search Database
 =====================
 */
public func conductDatabaseSearch() {
    
    // Initialize the array of City structs
    databaseSearchResults = [Tip]()
    
    // 1️⃣ Define the Fetch Request
    /*
     Create a fetchRequest to fetch City entities from the database.
     Since the fetchRequest's 'predicate' property is set to a NSPredicate condition,
     only those Recipe entities satisfying the condition will be fetched.
     */
    let fetchRequest = NSFetchRequest<Tip>(entityName: "Tip")
    
    /*
     List the fetched recipes in alphabetical order with respect to recipe category;
     If recipe category is the same, then sort with respect to recipe name.
     */
    fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "id", ascending: true),
    ]
    
    // 2️⃣ Define the Search Criteria
    
    switch searchCategory {
    case "Tip Title Contains":
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchQuery)
    case "Tip Content Contains":
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tipsContent", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "tipsContent CONTAINS[c] %@", searchQuery)
    default:
        print("Search category is out of range!")
    }
    
    do {
        // 3️⃣ Execute the Fetch Request
        databaseSearchResults = try managedObjectContext.fetch(fetchRequest)
        
    } catch {
        print("fetchRequest failed!")
    }

}
