//
//  AppDelegate.swift
//  PhotosVideos
//
//  Created by Osman Balci on 5/25/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        createClimatiqDatabase()        //Given in ClimatiqData.swift

//        // Read album photos data file upon app launch
//        readAlbumPhotosDataFile()
//
//        // Read album videos data file upon app launch
//        readAlbumVideosDataFile()
//
//        // Get permission to obtain user's geolocation upon app launch
//        getPermissionForLocation()
        
        createTipsDatabase()
        
        return true
    }

}
