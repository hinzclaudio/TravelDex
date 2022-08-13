//
//  File.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 13.08.22.
//

import UIKit
import MapKit



extension LocationDisplayController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKUserLocation {
            return nil
        } else {
            let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                for: annotation
            ) as! AddedPlaceAnnotationView
            view.configure(for: annotation)
            return view
        }
    }
    
    
}
