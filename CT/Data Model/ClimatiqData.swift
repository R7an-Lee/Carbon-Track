//
//  ClimatiqData.swift
//  CT
//
//  Created by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI
import CoreData

public func createClimatiqDatabase() {

    // ❎ Get object reference of Core Data managedObjectContext from the persistent container
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Climatiq>(entityName: "Climatiq")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "co2e", ascending: true)]
    
    var listOfAllClimatiqEntitiesInDatabase = [Climatiq]()
    
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllClimatiqEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Database Creation Failed!")
        return
    }
    
    if listOfAllClimatiqEntitiesInDatabase.count > 0 {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    // Local variable arrayOfClimatiqtructs obtained from the JSON file to create the database
    var arrayOfClimatiqStructs = [ClimatiqStruct]()
    
    arrayOfClimatiqStructs = decodeJsonFileIntoArrayOfStructs(fullFilename: "ClimatiqData.json", fileLocation: "Main Bundle")

    for aClimatiq in arrayOfClimatiqStructs {
        /*
         =============================
         *   Climatiq Entity Creation   *
         =============================
         */
        
        // 1️⃣ Create an instance of the Climatiq entity in managedObjectContext
        let climatiqEntity = Climatiq(context: managedObjectContext)
        
        // 2️⃣ Dress it up by specifying its attributes
        climatiqEntity.co2e = aClimatiq.co2e as NSNumber
        climatiqEntity.co2e_unit = aClimatiq.co2e_unit
        climatiqEntity.name = aClimatiq.name
        climatiqEntity.activity_id = aClimatiq.activity_id
        climatiqEntity.year = aClimatiq.year
        climatiqEntity.region = aClimatiq.region
        climatiqEntity.category = aClimatiq.category
        
        // 3️⃣ It has no relationship to another Entity
        
        /*
         *************************************
         ❎ Save Changes to Core Data Database
         *************************************
         */
        
        // The saveContext() method is given in Persistence.
        PersistenceController.shared.saveContext()
        
    }   // End of for loop

}
