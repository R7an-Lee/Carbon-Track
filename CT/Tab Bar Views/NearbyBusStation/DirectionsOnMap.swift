//
//  DirectionsOnMap.swift
//  VTQuest
//
//  Created by Osman Balci on 3/27/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//
 
import SwiftUI
import MapKit
import UIKit
 
struct DirectionsOnMap: UIViewRepresentable {
    /*
     ----------------
     Input Parameters
     ----------------
     */
    let latitudeFrom: Double
    let longitudeFrom: Double
    let latitudeTo: Double
    let longitudeTo: Double
    let mapType: MKMapType
    let directionsTransportType: MKDirectionsTransportType
   
    /*
     Instantiate an object from the MapViewDelegate class given below as conforming
     to the MKMapViewDelegate protocol so that we can implement its protocol method.
     */
    let mapViewDelegate = MapViewDelegate()
 
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
 
    func updateUIView(_ mapView: MKMapView, context: Context) {
        /*
         Designate mapView to be the delegate for the MKMapViewDelegate protocol so that we can implement its overlay protocol method
             func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
         in the MapViewDelegate class below to add the route's polyline as an overlay on top of the map.
         */
        mapView.delegate = mapViewDelegate
        addRoute(to: mapView)
    }
   
    func addRoute(to mapView: MKMapView) {
       
        if !mapView.overlays.isEmpty {
            mapView.removeOverlays(mapView.overlays)
        }
       
        //-----------------------------
        // Prepare to Obtain Directions
        //-----------------------------
       
        // Instantiate an object that specifies the start and end points of a route with mode of transportation
        let directionsRequest = MKDirections.Request()
       
        // Dress up the directions request object
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudeFrom, longitude: longitudeFrom), addressDictionary: nil))
 
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudeTo, longitude: longitudeTo), addressDictionary: nil))
       
        directionsRequest.requestsAlternateRoutes = false
       
        // Set directions transport type, e.g., .automobile, .walking
        directionsRequest.transportType = directionsTransportType
       
        //----------------------------
        // Compute and Show Directions
        //----------------------------
       
        // Instantiate an object that computes directions based on directionsRequest
        let directions = MKDirections(request: directionsRequest)
       
        directions.calculate { [] response, error in
            
            guard let unwrappedResponse = response else { return }
           
            for route in unwrappedResponse.routes {
                mapView.mapType = mapType
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
               
                /*
                 This calls the MKMapViewDelegate protocol method
                     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
                 implemented in the MapViewDelegate class below to add the route's polyline as an overlay on top of the map.
                 */
                mapView.addOverlay(route.polyline)
            }
        }
    }
 
    class MapViewDelegate: NSObject, MKMapViewDelegate {
       
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            /*
            Instantiate a MKPolylineRenderer object for visual polyline representation
            of the directions to be displayed as an overlay on top of the map.
            */
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
           
            // Dress up the polyline
            polylineRenderer.lineWidth = 1.0
            polylineRenderer.fillColor = UIColor.red
            polylineRenderer.strokeColor = UIColor.red
           
            return polylineRenderer
        }
    }
 
}
 
 
