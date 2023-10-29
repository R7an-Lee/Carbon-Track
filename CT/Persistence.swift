//
//  Persistence.swift
//  CT
//
//  Created by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import CoreData

struct PersistenceController {
    /*
     'shared' is the struct variable holding the instance reference of the newly created PersistenceController instance.
     It is referenced in any project file as PersistenceController.shared
     */
    static let shared = PersistenceController()

    // Property of the PersistenceController.shared instance
    let persistentContainer: NSPersistentContainer

    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "CT")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.

                /*
                Typical reasons for an error here include:
                    - The parent directory does not exist, cannot be created, or disallows writing.
                    - The persistent store is not accessible, due to permissions or data protection when the device is locked.
                    - The device is out of space.
                    - The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    //---------------------------------
    // MARK: ✳️ CoreData Save Operation
    //---------------------------------

    // Method of the PersistenceController.shared instance
    // Called in any project file as PersistenceController.shared.saveContext()
    func saveContext () {
        /*
         PersistenceController.shared.persistentContainer's property viewContext
         holds the object reference of the NSManagedObjectContext
         */
        let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.persistentContainer.viewContext
        
        // Check to see if managedObjectContext has any changes
        if managedObjectContext.hasChanges {
            do {
                // Try to save the changes
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
