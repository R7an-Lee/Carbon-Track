//
//  SearchTipsItem.swift
//  CT
//
//  Created by Yuxuan Li on 5/3/23.
//

import SwiftUI

struct SearchTipsItem: View {
    
    // ✳️ Input parameter: Core Data Video Entity instance reference
    let tip: Tip
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            Image(tip.tipsPhotoFilename ?? "Image Unavailble")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0)
            VStack(alignment: .leading) {
                Text(tip.title ?? "")
            }   //End of VStack
            .font(.system(size: 14))
        }   // End of HStack
    }
}
