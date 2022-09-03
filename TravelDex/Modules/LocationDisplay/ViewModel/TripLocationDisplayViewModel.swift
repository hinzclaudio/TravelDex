//
//  TripLocationDisplayViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit



class TripLocationDisplayViewModel: LocationDisplayViewModelType {
    
    typealias Dependencies = HasPlacesStore & HasTripsStore
    private let dependencies: Dependencies
    private let tripId: TripID
    
    init(dependencies: Dependencies, tripId: TripID) {
        self.dependencies = dependencies
        self.tripId = tripId
    }
    
    
    
    lazy var controllerTitle: Driver<String> = {
        dependencies.tripsStore
            .trip(identifiedBy: .just(tripId))
            .compactMap { $0?.title }
            .asDriver(onErrorJustReturn: "")
    }()
    
    lazy var annotations: Driver<[MKAnnotation]> = {
        dependencies.placesStore
            .places(for: .just(tripId))
            .map { [weak self ] places in places.map { place in LocationDisplayAnnotation(for: place) } }
            .asDriver(onErrorJustReturn: [])
    }()
    
}
