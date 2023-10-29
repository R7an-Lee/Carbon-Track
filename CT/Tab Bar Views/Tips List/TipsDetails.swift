//
//  TipsDetails.swift
//  CT
//
//  Created by 李雨轩 on 4/3/23.
//

import SwiftUI
import MapKit
import UIKit
import CoreData

struct TipsDetails: View {
    

    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Input Parameter
    let tip: Tip
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    @AppStorage("darkMode") private var darkMode = false
    
    
    
    var body: some View {
        Form {
            Group{
                Section(header: Text("Tips Title")) {
                    Text(tip.title ?? "")
                }
                Section(header: Text("Tips photo")) {
                    Image(uiImage: loadImage(filename: tip.tipsPhotoFilename ?? "ImageUnavailable"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                Section(header: Text("Tips").font(.system(size: 14))) {
                    Text(tip.tipsContent ?? "")
                        .font(.system(size: 14))
                }
                //implement some multimedia feature
                
            }   //End of Group
        }   // End of Form
        .navigationBarTitle(Text("City Details"), displayMode: .inline)
        .font(.system(size: 14))
    }   // End of body var
    
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
