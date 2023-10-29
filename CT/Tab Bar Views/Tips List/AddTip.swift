//
//  AddTip.swift
//  CT
//
//  Created by 李雨轩 on 5/3/23.
//

import SwiftUI
import CoreData

struct AddTip: View {
    
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ Core Data FetchRequest returning all music album entities in the database
    @FetchRequest(fetchRequest: Tip.allTipsFetchRequest()) var allCities: FetchedResults<Tip>
    
    // Subscribe to changes in Core Data database
    @EnvironmentObject var databaseChange: DatabaseChange
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //-------------------
    // Tips Entity
    //-------------------
    @State private var ttitle = ""
    @State private var tphoto = ""
    @State private var tcontent = ""
    @State private var tid = ""

    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    
    var body: some View {
        
        let camera = Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                if $0 == true {
                    usePhotoLibrary = false
                }
            }
        )
        let photoLibrary = Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                if $0 == true {
                    useCamera = false
                }
            }
        )
        
        Form {
            Group{
                Section(header: Text("Tip Title")) {
                    TextField("Enter Tip Title", text: $ttitle)
                }
                Section(header: Text("Tip Content")) {
                    TextField("Enter Tip Content", text: $tcontent)
                }
                //could add some website or stuff

                
            }   //End Of Group
            Group  {
                Section(header: Text("Take or Pick Photo")) {
                    VStack {
                        Toggle("Use Camera", isOn: camera)
                        Toggle("Use Photo Library", isOn: photoLibrary)

                        Button("Get Photo") {
                            showImagePicker = true
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
                if pickedImage != nil {
                    Section(header: Text("Taken or Picked Photo")) {
                        pickedImage?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
                    }
                }
                
            }   //End of Group3
            
        }   // End of Form
        .font(.system(size: 14))
        .disableAutocorrection(true)
        .autocapitalization(.none)
        .navigationBarTitle(Text("Add New City"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button("Save") {
                if inputEmptyCheck() {
                    showAlertMessage = true
                    alertTitle = "Missing Input Data!"
                    alertMessage = "Please enter all required Input data."
                }
            else{
                saveNewTip()
                showAlertMessage = true
                alertTitle = "New Tip Added!"
                alertMessage = "New Tip is successfully added to your database!"
                }
            }
        )
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "New City Added!" {
                    // Dismiss this view and go back to the previous view
                    dismiss()
                }
            }
        }, message: {
            Text(alertMessage)
        })
        .onChange(of: pickedUIImage) { _ in
            guard let uiImagePicked = pickedUIImage else { return }
            // Convert UIImage to SwiftUI Image
            pickedImage = Image(uiImage: uiImagePicked)
        }
        .sheet(isPresented: $showImagePicker) {
            /*
             For storage and performance efficiency reasons, we scale down the photo image selected from the
             photo library or taken by the camera to a smaller size with imageWidth and imageHeight in points.
             For high-resolution displays, 1 point = 3 pixels
             We use a square aspect ratio 1:1 for album cover photos with imageWidth = imageHeight = 200.0 points.
             You can select imageWidth and imageHeight values for other aspect ratios such as 4:3 or 16:9.
             imageWidth = 200.0 points and imageHeight = 200.0 points will produce an image with
             imageWidth = 600.0 pixels and imageHeight = 600.0 pixels which is about 84KB to 164KB in JPG format.
             */
            ImagePicker(uiImage: $pickedUIImage, sourceType: useCamera ? .camera : .photoLibrary, imageWidth: 200.0, imageHeight: 200.0)
        }
        
    }   // End of body var
    
    
    
    func inputEmptyCheck() -> Bool {
        if ttitle.isEmpty || tcontent.isEmpty {
            return true
        }
        return false
    }
    
    
    
    /*
     --------------------------
     MARK: Save New Tip
     --------------------------
     */
    func saveNewTip() {
        /*
         =============================
         *   City Entity Creation   *
         =============================
         */
        let photoFullFilename = UUID().uuidString + ".jpg"
        /*
         Convert pickedUIImage to a data object containing the
         image data in JPEG format with 100% compression quality
         */
        if let pickedUIImage = pickedUIImage {
            if let data = pickedUIImage.jpegData(compressionQuality: 1.0) {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileUrl = documentDirectory.appendingPathComponent(photoFullFilename)
                do {
                    try data.write(to: fileUrl)
                } catch {
                    print("Unable to write photo image to document directory!")
                }
            } else {
                print("Unable to get jpeg data from image!")
            }
        }
        // 1️⃣ Create an instance of the Album entity in managedObjectContext
        let tipEntity = Tip(context: managedObjectContext)
        // 2️⃣ Dress it up by specifying its attributes
        tipEntity.id = (allCities.count + 1) as NSNumber
        tipEntity.title = ttitle
        tipEntity.tipsPhotoFilename = photoFullFilename
        tipEntity.tipsContent = tcontent
        // 3️⃣ No relationships
        
        // ❎ Save Changes to Core Data Database
        PersistenceController.shared.saveContext()
        
        // Toggle database change indicator so that its subscribers can refresh their views
        databaseChange.indicator.toggle()
        
    }   // End of func saveNewCity()



}

