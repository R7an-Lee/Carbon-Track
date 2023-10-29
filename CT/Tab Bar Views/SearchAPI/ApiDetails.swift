//
//  ApiDetails.swift
//  CT
//
//  Created by Osman Balci on 4/10/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//

import SwiftUI

struct ApiDetails: View {
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    // ✳️ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ Core Data FetchRequest returning all Climatiq entities from the database
    @FetchRequest(fetchRequest: Climatiq.allClimatiqFetchRequest()) var allClimatiq: FetchedResults<Climatiq>
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
    var body: some View {
        /*
         foodItem global variable was obtained in NutritionixApiData.swift
         A Form cannot have more than 10 Sections. Group the Sections if more than 10.
         */
        Form {
            Group {
                Section(header: Text("CO2E")) {
                    Text("\(foundClimatiqList[0].co2e)")
                }
                Section(header: Text("CO2E Unit")) {
                    Text(foundClimatiqList[0].co2e_unit)
                }
                Section(header: Text("Name")) {
                    Text(foundClimatiqList[0].name)
                }
                Section(header: Text("Activity ID")) {
                    Text(foundClimatiqList[0].activity_id)
                }
                Section(header: Text("year")) {
                    Text(foundClimatiqList[0].year)
                }
                Section(header: Text("region")) {
                    Text(foundClimatiqList[0].region)
                }
                Section(header: Text("category")) {
                    Text(foundClimatiqList[0].category)
                }
                Section(header: Text("Add Data to Database as Favorite")) {
                    Button(action: {
                        saveClimatiqToDatabaseAsFavorite()
                        
                        showAlertMessage = true
                        alertTitle = "Data Added!"
                        alertMessage = "Selected data is added to your database as favorite."
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Add Data to Database")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            

        }   // End of Form
        .font(.system(size: 14))
        .navigationBarTitle(Text("Climatiq CO2 Emissions Details"), displayMode: .inline)
        
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "Data Added!" {
                    // Dismiss this view and go back to the previous view
                    dismiss()
                }
            }
        }, message: {
            Text(alertMessage)
        })

    }   // End of body var
    
    
    
    /*
     ----------------------------------------
     MARK: Save Climatiq Item to Database as Favorite
     ----------------------------------------
     */
    func saveClimatiqToDatabaseAsFavorite() {
        
        // 1️⃣ Create an instance of the Climatiq entity in managedObjectContext
        let climatiqEntity = Climatiq(context: managedObjectContext)
        
        // 2️⃣ Dress it up by specifying its attributes
        climatiqEntity.co2e = foundClimatiqList[0].co2e as NSNumber
        climatiqEntity.co2e_unit = foundClimatiqList[0].co2e_unit
        climatiqEntity.name = foundClimatiqList[0].name
        climatiqEntity.activity_id = foundClimatiqList[0].activity_id
        climatiqEntity.year = foundClimatiqList[0].year
        climatiqEntity.region = foundClimatiqList[0].region
        climatiqEntity.category = foundClimatiqList[0].category
        
        // 3️⃣ It has no relationship to another Entity
        
        // ❎ Save Changes to Core Data Database
        PersistenceController.shared.saveContext()
        
        // Toggle database change indicator so that its subscribers can refresh their views
        databaseChange.indicator.toggle()
    }
}

struct ApiDetails_Previews: PreviewProvider {
    static var previews: some View {
        ApiDetails()
    }
}
