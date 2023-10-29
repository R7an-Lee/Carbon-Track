//
//  ClimatiqStruct.swift
//  CT
//
//  Created by Ethan Springs on 5/1/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI

struct ClimatiqStruct: Hashable, Decodable {
    
    var co2e: Double
    var co2e_unit: String
    var name: String
    var activity_id: String
    var year: String
    var region: String
    var category: String
}

/*
 {
     "co2e": 131.425468416,
     "co2e_unit": "kg",
     "co2e_calculation_method": "ar4",
     "co2e_calculation_origin": "source",
     "emission_factor": {
         "name": "Black cab",
         "activity_id": "passenger_vehicle-vehicle_type_black_cab-fuel_source_na-distance_na-engine_size_na",
         "uuid": "ba32f6f2-9ec2-42eb-8ced-cd9d17a4491d",
         "id": "passenger_vehicle-vehicle_type_black_cab-fuel_source_na-distance_na-engine_size_na",
         "access_type": "public",
         "source": "BEIS",
         "source_dataset": "UK Government GHG Conversion Factors for Company Reporting",
         "year": "2022",
         "region": "GB",
         "category": "Road Travel",
         "lca_activity": "fuel_combustion",
         "data_quality_flags": []
     },
     "constituent_gases": {
         "co2e_total": 131.425468416,
         "co2e_other": null,
         "co2": 130.62079641600002,
         "ch4": 0.000077248512,
         "n2o": 0.002697260544
     }
 }
 */
