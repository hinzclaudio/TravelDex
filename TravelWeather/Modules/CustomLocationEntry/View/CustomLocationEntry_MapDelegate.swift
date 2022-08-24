//
//  CustomLocationEntry_MapDelegate.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import MapKit



extension CustomLocationEntryController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let _ = annotation as? MKUserLocation {
                return nil
            } else {
                let view = mapView.dequeueReusableAnnotationView(
                    withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                    for: annotation
                ) as! MKMarkerAnnotationView
                view.annotation = annotation
                return view
            }
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        displayedRegion.onNext(mapView.region)
    }
    
}
