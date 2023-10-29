//
//  BusStationDataFromApi.swift
//  CT
//
//  Created by Kewei Zhan on 5/2/23.
//  Copyright © 2023 Kewei Zhan. All rights reserved.
//

import Foundation
import MapKit

let currloca = currentLocation()
public var currlat = currloca.latitude
public var currlon = currloca.longitude


var foundStationList = [Place]()

public func getFoundBusStationFromApi(){
    let ApiUrl: String
    var jsonDataFromApi: Data
    
    let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    ApiUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(currlat),\(currlon)&radius=1500&type=transit_station&key=AIzaSyAqJ1v9eIHESoaKDRiJDR-rDrMNZo4tpeY"
    print(currlat)
    print(currlon)
    print(ApiUrl)
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: headers, apiUrl:  ApiUrl, timeout: 10.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }
    
    do {
        if let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi, options: []) as? [String: Any] {
            if let results = jsonResponse["results"] as? [[String: Any]] {
                for result in results {
                    if let geometry = result["geometry"] as? [String: Any],
                               let location = geometry["location"] as? [String: Double],
                               let photos = result["photos"] as? [[String: Any]],
                               let photoReference = photos.first?["photo_reference"] as? String,
                               let name = result["name"] as? String,
                               let vicinity = result["vicinity"] as? String {
                                
                                let latitude = location["lat"] ?? 0.0
                                let longitude = location["lng"] ?? 0.0
                                
                                // Create a Place object to store the data
                                let place = Place(latitude: latitude, longitude: longitude, photoReference: photoReference, name: name, vicinity: vicinity)
                                
                                foundStationList.append(place)
                            }
                }
            }
        }

    } catch {
        return
    }

}
