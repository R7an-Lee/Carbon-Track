//
//  ClimatiqFavoriteItem.swift
//  CT
//
//  Created by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI

struct ClimatiqFavoriteItem: View {
    
    // ✳️ Input parameter: Core Data Climatiq Entity instance reference
    let climatiq: Climatiq
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            Image("climatiqlogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0)
            
            VStack(alignment: .leading) {
                Text(climatiq.category ?? "")
                //let co2eVal = climatiq.co2e ?? 0.0
                //Text(String(format: "%.2f", co2eVal) + " kg CO2")
                Text("\(climatiq.co2e ?? 0.0) kg CO2")
                Text(climatiq.year ?? "")
                Text(climatiq.region ?? "")
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
            
        }   // End of HStack
    }
}
