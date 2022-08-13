//
//  LocationDisplayViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 11.08.22.
//

import Foundation
import RxCocoa
import MapKit



protocol LocationDisplayViewModelType {
    
    // MARK: - Input
    // TODO
    
    
    // MARK: - Output
    var tripName: Driver<String> { get }
    var annotations: Driver<[MKAnnotation]> { get }
    
}
