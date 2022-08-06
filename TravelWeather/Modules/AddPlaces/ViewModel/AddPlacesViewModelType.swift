//
//  AddPlacesViewModelType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



protocol AddPlacesViewModelType {
    
    // MARK: - Input
    
    
    // MARK: - Output
    var trip: Driver<Trip> { get }
    
}
