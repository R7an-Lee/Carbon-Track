//
//  BusStationsOnMapDetails.swift
//  CT
//
//  Created by william zhan on 5/2/23.
//

import SwiftUI
import MapKit
import UIKit

struct BusStationsOnMapDetails: View {
    
    let station: Place
    @State private var selectedMapTypeIndex1 = 0
    var mapTypes = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        Form{
            Section(header: Text("Station Name")){
                Text(station.name)
            }
            Group{
                Section(header: Text("Station Image")){
                   
                    
                    getImageFromUrl(url: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(station.photoReference)&key=AIzaSyAqJ1v9eIHESoaKDRiJDR-rDrMNZo4tpeY", defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                }
                Section(header: Text("Map Type")){
                    Text("Select Map Type")
                    mapTypePicker
                }
            }
            Group{
                Section(header: Text("Directions To Selected Bus Station")) {
                    NavigationLink(destination: showDirectionsOnMap) {
                        HStack {
                            Image(systemName: "arrow.up.right.diamond")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Directions on Map")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                    
                    
                }
                Section(header: Text("Station vicinity")){
                    Text(station.vicinity)
                }
            }
            .navigationBarTitle("\(station.name) Station Detail", displayMode: .inline)
        }
    } //end of body

var mapTypePicker: some View {
    Picker("Select Map Type", selection: $selectedMapTypeIndex1) {
        ForEach(0 ..< mapTypes.count, id: \.self) { index in
            Text(mapTypes[index]).tag(index)
        }
    }
    .pickerStyle(SegmentedPickerStyle())
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
}
    
    var showDirectionsOnMap: some View {
        
        var mapType1: MKMapType
        
        switch selectedMapTypeIndex1 {
        case 0:
            mapType1 = MKMapType.standard
        case 1:
            mapType1 = MKMapType.satellite
        case 2:
            mapType1 = MKMapType.hybrid
        case 3:
            mapType1 = MKMapType.hybridFlyover
        default:
            fatalError("Map type is out of range!")
        }
        
        var transportType: MKDirectionsTransportType
        
        transportType = .walking
        
        let currentGeolocation = currentLocation()
        let latitudeFrom = currentGeolocation.latitude
        let longitudeFrom = currentGeolocation.longitude
        
        return AnyView(
            VStack {
                // Display "from current location to where" as centered multi lines
                Text("From Current Location to Selected Bus Station")
                    .font(.custom("Helvetica", size: 10))
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .multilineTextAlignment(.center)
                
                // Display directions on map
                DirectionsOnMap(latitudeFrom:   latitudeFrom,
                                longitudeFrom:  longitudeFrom,
                                latitudeTo:     station.latitude,
                                longitudeTo:    station.longitude,
                                mapType: mapType1,
                                directionsTransportType: transportType)
                
                .navigationBarTitle(Text("Walking Directions"), displayMode: .inline)
            }
        )
    }// end func
    

}
