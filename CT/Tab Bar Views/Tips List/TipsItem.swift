//
//  TipsItem.swift
//  CT
//
//  Created by 李雨轩 on 4/3/23.
//

import SwiftUI

struct TipsItem: View {
    
    
    let tip: Tip
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    var body: some View {
        HStack {
            Image(uiImage: loadImage(filename: tip.tipsPhotoFilename ?? "ImageUnavailable"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0)
            VStack(alignment: .leading) {
                Text(tip.title ?? "")
            }   //End of VStack
            .font(.system(size: 14))
        }   // End of HStack
    }
    
    func loadImage(filename: String) -> UIImage {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectory.appendingPathComponent(filename)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            guard let image = UIImage(data: imageData) else {
                print("Error: Unable to create UIImage from the provided data")
                return UIImage(named: filename) ?? UIImage(named: "ImageUnavailable")!
            }
            return image
        } catch {
            print("Error loading image from document directory: \(error)")
            return UIImage(named: filename) ?? UIImage(named: "ImageUnavailable")!
        }
    }

    
}
