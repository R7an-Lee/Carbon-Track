//
//  ClimatiqFavoriteList.swift
//  CT
//
//  Created by Osman Balci on 3/20/23.
//  Modified by Ethan Springs on 5/1/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI
import CoreData

struct ClimatiqFavoriteList: View {
    
    // ❎ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ Core Data FetchRequest returning all Climatiq entities from the database
    @FetchRequest(fetchRequest: Climatiq.allClimatiqFetchRequest()) var allClimatiq: FetchedResults<Climatiq>
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationView {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Climatiq items in a dynamic scrollable list.
                 */
                ForEach(allClimatiq) { aClimatiq in
                    NavigationLink(destination: ClimatiqFavoriteDetails(climatiq: aClimatiq)) {
                        ClimatiqFavoriteItem(climatiq: aClimatiq)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete this item? It cannot be undone."),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                    'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                     element to be deleted. It is nil if the array is empty. Process it as an optional.
                                    */
                                    if let index = toBeDeleted?.first {
                                       
                                        let climatiqToDelete = allClimatiq[index]
                                        
                                        // ❎ Delete Selected Climatiq entity from the database
                                        managedObjectContext.delete(climatiqToDelete)

                                        // ❎ Save Changes to Core Data Database
                                        PersistenceController.shared.saveContext()
                                        
                                        // Toggle database change indicator so that its subscribers can refresh their views
                                        databaseChange.indicator.toggle()
                                    }
                                    toBeDeleted = nil
                                }, secondaryButton: .cancel() {
                                    toBeDeleted = nil
                                }
                            )
                        }   // End of alert
                    }
                }
                .onDelete(perform: delete)
                //.onMove(perform: move)
                
            }   // End of List
            .navigationBarTitle(Text("Favorites"), displayMode: .inline)
            
            // Place the Edit button on left of the navigation bar
            .navigationBarItems(leading: EditButton())
            
        }   // End of NavigationView
        .customNavigationViewStyle()  // Given in NavigationStyle
        
    }   // End of body
    
    /*
     ----------------------------------------
     MARK: Delete Selected Climatiq favorite
     ----------------------------------------
     */
    func delete(at offsets: IndexSet) {
        
         toBeDeleted = offsets
         showConfirmation = true
     }
    
}   // End of struct


struct ClimatiqFavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        ClimatiqFavoriteList()
    }
}
