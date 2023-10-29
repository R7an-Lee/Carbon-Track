//
//  TipsStruct.swift
//  CT
//
//  Created by 李雨轩 on 4/3/23.
//

import SwiftUI

struct TipsStruct: Hashable, Decodable {
    
    var id: Int32
    var title: String
    var tipsPhotoFilename: String
    var tipsContent: String
    
}
/*
 {
     "id": 1,
     "title": "Save energy with bulbs",
     "tipsPhotoFilename": "Electric",
     "tipsContent": "Take advantage of the daylight by turning off lights when you don’t need them. Keeping the lights off when you’re not at home can save you up to 40% on your energy bill. Replace any incandescent or compact fluorescent lightbulbs in your home with LED bulbs. Why? LEDs can help you use up to 80% less energy than incandescent bulbs — and because they can last more than 20 years, they rarely need replacing.Get in the habit of unplugging small appliances when they’re not in use. Appliances account for about 20% of all energy used in the home.Bonus tip: Use power strips for your electronics so you can switch them all off at once. Doing that can save you up to $100 a year.",
 },
 */
