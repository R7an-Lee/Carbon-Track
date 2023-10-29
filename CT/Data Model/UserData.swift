//
//  UserData.swift
//  PhotosVideos
//
//  Created by Osman Balci on 5/25/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    /*
     ===============================================================================
     |                   Publisher-Subscriber Design Pattern                       |
     ===============================================================================
     | Publisher:   @Published var under class conforming to ObservableObject      |
     | Subscriber:  Any View declaring '@EnvironmentObject var userData: UserData' |
     ===============================================================================
     
     By modifying the first View to be shown, ContentView(), with '.environmentObject(UserData())' in
     Photo_AlbumApp, we inject an instance of this UserData() class into the environment and make it
     available to every View subscribing to it by declaring '@EnvironmentObject var userData: UserData'.
     
     When a change occurs in UserData, every View subscribed to it is notified to re-render its View.
     */
    
    /*
     ---------------------------
     |   Published Variables   |
     ---------------------------
     */
    
        @Published var stationList = foundStationList
//
//    // Publish videosList with initial value of albumVideoStructList obtained in AlbumPhotosData.swift
//    @Published var videosList = albumVideoStructList
    
}

