//
//  LocationDisplayViewModelType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.08.22.
//

import Foundation
import RxCocoa
import MapKit



protocol LocationDisplayViewModelType {
    
    var controllerTitle: Driver<String> { get }
    var annotations: Driver<[MKAnnotation]> { get }
    
}
