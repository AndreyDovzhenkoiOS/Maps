//
//  MainViewModel.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import Foundation
import MapKit

final class MainViewModel: NSObject {
    
    //MARK: - Property
    
    var selectedPlacemark: MKPlacemark!
    var userLocation: CLLocation!
    var completionHandler = {(_ : MKCoordinateRegion) -> () in}
    
    //MARK: - Funstions
    
    public func zoomLocation(_ cordinateSpan: Double, _ location: CLLocation) {
        let span = MKCoordinateSpanMake(cordinateSpan, cordinateSpan)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        completionHandler(region)
    }
    
    public func direction() {
        let mapItem = MKMapItem(placemark: selectedPlacemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    public func getAnnotation(_ placemark: MKPlacemark) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = placemark.fullAdress
        return annotation
    }
}
