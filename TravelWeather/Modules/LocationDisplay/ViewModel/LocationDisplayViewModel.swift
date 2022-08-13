//
//  LocationDisplayViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 11.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit



class LocationDisplayViewModel: LocationDisplayViewModelType {
    
    typealias Dependencies = HasPlacesStore & HasTripsStore
    private let dependencies: Dependencies
    private let tripId: TripID
    private let locationId: LocationID?
    
    init(dependencies: Dependencies, tripId: TripID, highlight locationId: LocationID? = nil) {
        self.dependencies = dependencies
        self.tripId = tripId
        self.locationId = locationId
    }
    
    
    // MARK: - Input
    
    
    // MARK: - Output
    lazy var tripName: Driver<String> = {
        dependencies.tripsStore
            .trip(identifiedBy: .just(tripId))
            .compactMap { $0?.title }
            .asDriver(onErrorJustReturn: "")
    }()
    
    lazy var annotations: Driver<[MKAnnotation]> = {
        dependencies.placesStore
            .addedPlaces(for: .just(tripId))
            .map { [weak self ] places in
                places
                    .map { place in
                        LocationDisplayAnnotation(
                            for: place,
                            highlighted: place.location.id == self?.locationId
                        )
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }()
    
}
