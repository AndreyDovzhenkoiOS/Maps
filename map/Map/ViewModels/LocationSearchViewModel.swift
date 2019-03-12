//
//  LocationSearchViewModel.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import Foundation
import MapKit

final class LocationSearchViewModel: NSObject {
    
    //MARK: - Property
    
    var mapItems: [MKMapItem] = []
    var completionHandlerSearch = {() -> () in}
    var isSearchPlacemark = true
    
    
    //MARK: - Funstions
    
    public func updateSearchResult(_ string: String, _ region: MKCoordinateRegion) {
        if isSearchPlacemark {
            searchRequest(string, region) {
                self.search($0)
            }
        }
    }
    
    private func searchRequest(_ string: String,_ region: MKCoordinateRegion,
                               _ completion: @escaping(MKLocalSearchRequest) -> ()) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = string
        request.region = region
        completion(request)
    }
    
    private func search(_ request: MKLocalSearchRequest) {
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {return}
            self.mapItems = response.mapItems
            self.completionHandlerSearch()
        }
    }
}
