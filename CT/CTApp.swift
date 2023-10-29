//
//  CTApp.swift
//  CT
//  This app is aiming to track carbons we produced each trip
//
//

import SwiftUI

@main
struct CTApp: App {
    
    @AppStorage("darkMode") private var darkMode = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            // ContentView is the root view to be shown first upon app launch
            ContentView()
            // Change the color mode of the entire app to Dark or Light
            .preferredColorScheme(darkMode ? .dark : .light)
        
            /*
             Inject managedObjectContext into ContentView as an environment variable
             so that it can be referenced in any SwiftUI view as
                @Environment(\.managedObjectContext) var managedObjectContext
             */
            .environment(\.managedObjectContext, managedObjectContext)
            /*
             Inject an instance of DatabaseChange() class into the environment and
             make it available to every View subscribing to it.
             */
            .environmentObject(DatabaseChange())
        }
        .onChange(of: scenePhase) { _ in
            /*
             Save database changes if any whenever app life cycle state
             changes. The saveContext() method is given in Persistence.
             */
            PersistenceController.shared.saveContext()
        }
    }
}


