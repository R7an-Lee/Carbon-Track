//
//  ApiSearchEnergy.swift
//  CT
//
//  Created by Ethan Springs on 5/1/23.
//

import SwiftUI

struct ApiSearchEnergy: View {
    
    @State private var searchCountry = ""
    @State private var kwhText = "0"
    @State private var kwh = 0
    @State private var searchCompleted = false
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Enter energy consumption in KiloWatt Hours")) {
                HStack {
                    TextField("kWh", text: $kwhText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .onSubmit {
                            if let num = Int(kwhText) {
                                kwh = num
                            } else {
                                showAlertMessage = true
                                alertTitle = "Invalid kWh Value!"
                                alertMessage = "Entered kWh value \(kwhText) is not a number."
                            }
                        }
                    // Button to clear the text field
                    Button(action: {
                        kwhText = "0"
                        kwh = 0
                        showAlertMessage = false
                        searchCompleted = false
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    
                }   //end of HStack
            }
            Section (header: Text("Enter 2-letter country code")) {
                HStack {
                    TextField("Eg: US, AU, EU", text: $searchCountry)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                    
                    // Button to clear the text field
                    Button(action: {
                        searchCountry = ""
                        showAlertMessage = false
                        searchCompleted = false
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    
                }   // End of HStack
                
            }
            
            
            Section(header: Text("Search Climatiq API")) {
                HStack {
                    Spacer()
                    Button(searchCompleted ? "Search Completed" : "Search") {
                        if inputDataValidated() {
                            searchApi()
                            searchCompleted = true
                        } else {
                            showAlertMessage = true
                            alertTitle = "Missing Input Data!"
                            alertMessage = "Please enter a search query!"
                        }
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                    Spacer()
                }   // End of HStack
            }
            
            if searchCompleted {
                Section(header: Text("View Emissions Data")) {
                    NavigationLink(destination: showSearchResults) {
                        HStack {
                            Image(systemName: "list.bullet")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("View Emissions Data")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            
        }   // End of Form
        .navigationBarTitle(Text("Search Climatiq API"), displayMode: .inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
        
    }   // End of body var
    
    /*
     ----------------
     MARK: Search API
     ----------------
     */
    
    
    func searchApi() {
        //API Key: SBX5EFZAN0MEDNPD0NB78DQRBTAN
        DataFromApi(kwhours: kwh, region: searchCountry) { (result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("No data returned")
                return
            }
            foundClimatiqList = [ClimatiqStruct]()
            
            print("result: \(result)")
            var co2e = 0.0
            var co2eUnit = ""
            
            
            if let co2eDouble = result["co2e"] as? Double {
                co2e = co2eDouble
                print("CO2e: \(co2e)")
            }
            
            if let co2eUnitString = result["co2e_unit"] as? String {
                co2eUnit = co2eUnitString
                print("CO2e unit: \(co2eUnit)")
            }
            
            if let emissionFactor = result["emission_factor"] as? [String: Any],
               let name = emissionFactor["name"] as? String,
               let activityId = emissionFactor["activity_id"] as? String,
               let category = emissionFactor["category"] as? String,
               let year = emissionFactor["year"] as? String,
               let region = emissionFactor["region"] as? String {
                print("Name: \(name)")
                print("Activity ID: \(activityId)")
                print("Category: \(category)")
                print("Year: \(year)")
                print("Region: \(region)")
                
                let climatiqItem = ClimatiqStruct(co2e: co2e, co2e_unit: co2eUnit, name: name, activity_id: activityId, year: year, region: region, category: category)
                foundClimatiqList.append(climatiqItem)
            }
        }
        
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        /*
         Search results are obtained in ApiSearchEnergy.swift and
         stored in the global var foundClimatiqItem = [ClimatiqStruct]()
         */
        if foundClimatiqList[0].name.isEmpty {
            return AnyView(
                NotFound(message: "Nothing Found!\n\nThe entered query did not return any data from the API! Please enter another search query.")
            )
        }

        return AnyView(ApiDetails())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed = searchCountry.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty || kwhText.isEmpty {
            return false
        }
        return true
    }
    
}

struct ApiSearchEnergy_Previews: PreviewProvider {
    static var previews: some View {
        ApiSearchEnergy()
    }
}
