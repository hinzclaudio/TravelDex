//
//  File.swift
//  TravelDex
//
//  Created by Claudio Hinz on 13.08.22.
//

import UIKit
import MapKit



extension LocationDisplayController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKUserLocation {
            return nil
        } else if let annotation = annotation as? LocationDisplayAnnotation {
            let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                for: annotation
            ) as! MKMarkerAnnotationView
            view.annotation = annotation
            view.markerTintColor = annotation.pinColor
            return view
        } else {
            assertionFailure("Something's missing...")
            return nil
        }
    }
    
    
}
