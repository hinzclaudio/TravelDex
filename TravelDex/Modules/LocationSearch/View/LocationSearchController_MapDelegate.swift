//
//  LocationSearchController_MapDelegate.swift
//  TravelDex
//
//  Created by Claudio Hinz on 18.08.22.
//

import UIKit
import MapKit



extension LocationSearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation,
           let locationAnnotation = annotation as? LocationSearchAnnotation {
            selection.onNext(locationAnnotation.location)
        } else {
            assertionFailure("Something's missing...")
        }
    }
    
    
    
    
}
