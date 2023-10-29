//
//  TipsData.swift
//  CT
//
//  Created by Yuxuan Li on 4/3/23.
//

import SwiftUI
import CoreData

// Array of CompanyStruct structs obtained from the JSON file
// for use only in this file to create the database
//fileprivate var arrayOfCompanyStructs = [CitiesStruct]()

public func createTipsDatabase() {

    // ❎ Get object reference of Core Data managedObjectContext from the persistent container
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    
    let fetchRequest = NSFetchRequest<Tip>(entityName: "Tip")
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    var listOfAllTipEntitiesInDatabase = [Tip]()
    
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllTipEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Database Creation Failed!")
        return
    }
    
    if listOfAllTipEntitiesInDatabase.count > 0 {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    var arrayOfTipStructs = [TipsStruct]()
    
    arrayOfTipStructs = decodeJsonFileIntoArrayOfStructs(fullFilename: "TipsData.json", fileLocation: "Main Bundle")

    for aTip in arrayOfTipStructs {
        /*
         ===============================
         *   Cities Entity Creation   *
         ===============================
         */
        
        // 1️⃣ Create an instance of the City entity in managedObjectContext
        let tipEntity = Tip(context: managedObjectContext)
        
        // 2️⃣ Dress it up by specifying its attributes
        tipEntity.id = aTip.id as NSNumber
        tipEntity.title = aTip.title
        tipEntity.tipsPhotoFilename = aTip.tipsPhotoFilename
        tipEntity.tipsContent = aTip.tipsContent
        // 3️⃣ no relationships

        // ❎ Save Changes to Core Data Database
        PersistenceController.shared.saveContext()
        
    }   // End of for loop

}

