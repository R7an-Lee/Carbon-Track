//
//  ApiSearchEnergy.swift
//  CT
//
//  Created by Ethan Springs on 5/1/23.
//

import SwiftUI

struct ApiSearchFlight: View {
    
    @State private var passengerText = "0"
    @State private var passenger = 0
    @State private var distanceText = "0"
    @State private var distance = 0
    @State private var searchCompleted = false
    
    let travelMethods = ["Air", "Train", "Car", "Boat"]
    @State private var travelMethodsIndex = 0       // Air
    
    let travelMethodsID = ["passenger_flight-route_type_domestic-aircraft_type_jet-distance_na-class_na-rf_included", "passenger_train-route_type_commuter_rail-fuel_source_na", "passenger_vehicle-vehicle_type_black_cab-fuel_source_na-distance_na-engine_size_na", "passenger_ferry-route_type_car_passenger-fuel_source_na"]
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Select Method of Transportation")) {
                Picker("", selection: $travelMethodsIndex) {
                    ForEach(0 ..< travelMethods.count, id: \.self) {
                        Text(travelMethods[$0])
                    }
                }
            }
            Section(header: Text("Enter number of passengers")) {
                HStack {
                    TextField("Number of passengers", text: $passengerText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .onSubmit {
                            if let num = Int(passengerText) {
                                passenger = num
                            } else {
                                showAlertMessage = true
                                alertTitle = "Invalid Passenger Value!"
                                alertMessage = "Entered passenger value \(passengerText) is not a number."
                            }
                        }
                    Button(action: {
                        passengerText = "0"
                        passenger = 0
                        showAlertMessage = false
                        searchCompleted = false
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    
                }       //end of HStack
            }
            Section(header: Text("Enter distance in miles")) {
                HStack {
                    TextField("Distance", text: $distanceText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .onSubmit {
                            if let num = Int(distanceText) {
                                distance = num
                            } else {
                                showAlertMessage = true
                                alertTitle = "Invalid Distance Value!"
                                alertMessage = "Entered distance value \(distanceText) is not a number."
                            }
                        }
                    Button(action: {
                        distanceText = "0"
                        distance = 0
                        showAlertMessage = false
                        searchCompleted = false
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    
                }   //end of HStack
            }
            
            
            
            Section(header: Text("Search ClimatiqAPI")) {
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
        let travelMethodId = travelMethodsID[travelMethodsIndex]
        
        FlightDataFromApi(passengers: passenger, distance: distance, type: travelMethodId) { (result, error) in
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
             Search results are obtained in ApiSearchFlight.swift and
             stored in the global var foundClimatiqList = [ClimatiqStruct]()
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
        let passengerTrimmed = passengerText.trimmingCharacters(in: .whitespacesAndNewlines)
        let distanceTrimmed = distanceText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if passengerTrimmed.isEmpty || distanceTrimmed.isEmpty {
            return false
        }
        return true
    }
    
}

struct ApiSearchFlight_Previews: PreviewProvider {
    static var previews: some View {
        ApiSearchFlight()
    }
}
