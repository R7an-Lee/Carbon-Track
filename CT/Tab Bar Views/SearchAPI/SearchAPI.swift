//
//  SearchApi.swift
//  CT
//
//  Created by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI

var foundClimatiqList = [ClimatiqStruct]()

struct SearchApi: View {
    
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()
                    NavigationLink(destination: ApiSearchEnergy()) {
                        VStack {
                            Image("energyIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                            Text("Calculate CO2 Emissions from energy usage")
                                .font(.headline)
                                .padding()
                        }
                    }
                    .padding(.bottom,30)
                    
                    NavigationLink(destination: ApiSearchFlight()) {
                        VStack {
                            Image("transportationIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                            Text("Calculate CO2 Emissions from flight details")
                                .font(.headline)
                                .padding()
                        }
                    }
                    Spacer()
                }   // End of VStack
            }   // End of ScrollView
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
        
    }   // End of body var
}

struct SearchApi_Previews: PreviewProvider {
    static var previews: some View {
        SearchApi()
    }
}
