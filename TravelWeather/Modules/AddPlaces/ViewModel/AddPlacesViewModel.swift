//
//  AddPlacesViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class AddPlacesViewModel: AddPlacesViewModelType {
    
    weak var coordinator: AppCoordinator?

    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    private let initialTrip: Trip
    
    init(dependencies: Dependencies, trip: Trip) {
        self.dependencies = dependencies
        self.initialTrip = trip
    }
    
    
    
    // MARK: - Input
    
    
    // MARK: - Output
    lazy var trip: Driver<Trip> = {
        dependencies.tripsStore
            .trip(identifiedBy: .just(initialTrip.id))
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: initialTrip)
    }()
    
}
