//
//  ClimatiqFavoriteDetails.swift
//  CT
//
//  Created by Osman Balci on 4/10/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//

import SwiftUI

struct ClimatiqFavoriteDetails: View {
    
    let climatiq: Climatiq
    
    var body: some View {
        /*
         foodItem global variable was obtained in NutritionixApiData.swift
         A Form cannot have more than 10 Sections. Group the Sections if more than 10.
         */
        Form {
            Group {
                Section(header: Text("CO2E")) {
                    Text("\(climatiq.co2e ?? 0.0)")
                }
                Section(header: Text("CO2E Unit")) {
                    Text(climatiq.co2e_unit ?? "")
                }
                Section(header: Text("Name")) {
                    Text(climatiq.name ?? "")
                }
                Section(header: Text("Activity ID")) {
                    Text(climatiq.activity_id ?? "")
                }
                Section(header: Text("year")) {
                    Text(climatiq.year ?? "")
                }
                Section(header: Text("region")) {
                    Text(climatiq.region ?? "")
                }
                Section(header: Text("category")) {
                    Text(climatiq.category ?? "")
                }
            }
            

        }   // End of Form
        .navigationBarTitle(Text("Climatiq CO2 Emissions Details"), displayMode: .inline)
        .font(.system(size: 14))
    }
}

