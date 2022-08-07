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
    func addLocation(_ tapped: Observable<Void>) -> Disposable
    
    // MARK: - Output
    var trip: Driver<Trip> { get }
    var addedPlaces: Driver<[AddedPlaceItem]> { get }
    
}
