//
//  LocationDisplayAnnotation.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 12.08.22.
//

import Foundation
import MapKit



class LocationDisplayAnnotation: NSObject, MKAnnotation {
    
    let item: AddedPlaceItem
    
    var title: String? {
        item.location.name
    }
    
    var pinColor: UIColor {
        item.pinColor
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: item.location.coordinate.latitude,
            longitude: item.location.coordinate.longitude
        )
    }
    
    
    init(for item: AddedPlaceItem) {
        self.item = item
        super.init()
    }
    
}
