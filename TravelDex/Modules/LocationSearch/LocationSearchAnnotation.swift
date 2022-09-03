//
//  LocationSearchAnnotation.swift
//  TravelDex
//
//  Created by Claudio Hinz on 18.08.22.
//

import Foundation
import MapKit



class LocationSearchAnnotation: NSObject, MKAnnotation {
    
    let location: Location
    
    var title: String? {
        location.name
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    
    init(loc: Location) {
        self.location = loc
        super.init()
    }
    
}
