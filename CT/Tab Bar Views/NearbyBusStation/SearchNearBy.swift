//
//  SearchNearBy.swift
//  CT
//
//  Created by william zhan on 5/2/23.
//

import SwiftUI
import MapKit
import UIKit

struct SearchNearByBusStation: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    Image("bus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300, alignment: .center)
                }
                Group{
                    Section(header: Text("Nearby Bus Station On Map")) {
                        
                        NavigationLink(destination: BusStationOnMap()) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Show Business on Map")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                        
                    }
                    
                }
            }
            .navigationBarTitle(Text("Search Nearby Bus Station"), displayMode: .inline)
        }
        .onAppear {
            getFoundBusStationFromApi()
            foundStationList.forEach { station in
                print("Error here: station is emptuy", station)
            }
        }
        .customNavigationViewStyle()
        
    }}
