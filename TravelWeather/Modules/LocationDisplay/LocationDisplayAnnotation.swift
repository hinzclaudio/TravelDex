//
//  LocationDisplayAnnotation.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 12.08.22.
//

import Foundation
import MapKit



class LocationDisplayAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let img: UIImage?
    let highlighted: Bool
    let coordinate: CLLocationCoordinate2D
    
    init(for item: AddedPlaceItem, highlighted: Bool) {
        self.title = item.location.name
        if let data = item.visitedPlace.picture {
            self.img = UIImage(data: data)
        } else {
            self.img = nil
        }
        self.highlighted = highlighted
        self.coordinate = .init(
            latitude: item.location.coordinate.latitude,
            longitude: item.location.coordinate.longitude
        )
        super.init()
    }
    
}
