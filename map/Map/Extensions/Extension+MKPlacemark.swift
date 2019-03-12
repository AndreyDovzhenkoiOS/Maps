//
//  Extension+MKPlacemark.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import MapKit

extension MKPlacemark {
    
    var fullAdress: String {
        let arrangementText = getArrangementText()
        
        let streetNumber = subThoroughfare ?? ""
        let streetName = thoroughfare ?? ""
        let city = locality ?? ""
        let state = administrativeArea ?? ""
        
        let adress = String(
            format:"%@%@%@%@%@%@%@",
            streetNumber, arrangementText.firstSpace,
            streetName, arrangementText.comma,
            city, arrangementText.secondSpace,
            state)
        
        return adress
    }
    
    private func getArrangementText() ->
        (firstSpace: String, secondSpace: String, comma: String) {
            let isFirstSpace = subThoroughfare != nil && thoroughfare != nil
            let isComma = (subThoroughfare != nil || thoroughfare != nil) && (subAdministrativeArea != nil || administrativeArea != nil)
            let isSecondSpace = subAdministrativeArea != nil && administrativeArea != nil
            
            let firstSpace = isFirstSpace ? " " : ""
            let comma = isComma  ? ", " : ""
            let secondSpace = isSecondSpace ? " " : ""
            
            return (firstSpace,secondSpace,comma)
    }
}
