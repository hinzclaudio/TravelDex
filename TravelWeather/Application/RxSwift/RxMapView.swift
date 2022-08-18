//
//  Rx+MapView.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 12.08.22.
//

import RxSwift
import RxCocoa
import MapKit



extension Reactive where Base: MKMapView {
    
    var animatedAnnotations: AnyObserver<[MKAnnotation]> {
        Binder(base) { mapView, annotations in
            mapView
                .annotations
                .forEach(mapView.removeAnnotation(_:))
            mapView
                .showAnnotations(annotations, animated: true)
        }
        .asObserver()
    }
    
}
