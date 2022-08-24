//
//  DragAnnotation.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import MapKit



class DragAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: Coordinate) {
        self.title = "Custom Location"
        self.subtitle = "Drag to the location you want to choose..."
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        super.init()
    }
    
}
