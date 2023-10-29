//
//  BusStationOnMap.swift
//  CT
//
//  Created by william zhan on 5/2/23.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit

fileprivate var stationlist = [Place]()
struct Location: Identifiable {
    var id = UUID()
    var station: Place
    var coordinate: CLLocationCoordinate2D
}

struct BusStationOnMap: View {
    
    @State private var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: currlat,
            longitude: currlon
        ),
        // 1 degree = 69 miles. 0.02 degree = 1.38 miles
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
    )
    
    var body: some View {
        stationNearBy
                
        
        .navigationBarTitle(Text("Bus Station near your current location"), displayMode: .inline)
    }
    
    var stationNearBy: some View {
        stationlist = foundStationList
        var annotations = [Location]()
        for aStation in stationlist{
            annotations.append(Location(station: aStation, coordinate: CLLocationCoordinate2D(latitude: aStation.latitude, longitude: aStation.longitude)))
        }
        return AnyView(
            Map(coordinateRegion: $coordinateRegion,
                interactionModes: .all,
                showsUserLocation: false,
                annotationItems: annotations)
                    { item in
                        MapAnnotation(coordinate: item.coordinate) {
                            CustomView(station: item.station)
                        }
                    }
        )
    }
}

struct CustomView: View {
    let station: Place
    @State private var showText = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            if showText {
                NavigationLink(destination: BusStationsOnMapDetails(station: station)){
                    Text(station.name)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(10)
                    // Prevent building name truncation
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            Image(systemName: "bus")
                .imageScale(.small)
                .font(Font.title.weight(.regular))
                .foregroundColor(.red)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showText.toggle()
                    }
                }
        }
    }
}





