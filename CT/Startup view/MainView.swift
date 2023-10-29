//
//  MainView.swift
//  
//  This class generate the main view of the app
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ClimatiqFavoriteList()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Climatiq Favorite")
                }
            SearchApi()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search API")
                }
            SearchNearByBusStation()
                .tabItem{
                    Image(systemName: "mappin.and.ellipse")
                    Text("On Map")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            TipsList()
                .tabItem {
                    Image(systemName: "list.star")
                    Text("Tips List")
                }
            SearchTips()
                .tabItem {
                    Image(systemName:"magnifyingglass")
                    Text("Search  Tips")
                }
            
            
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
