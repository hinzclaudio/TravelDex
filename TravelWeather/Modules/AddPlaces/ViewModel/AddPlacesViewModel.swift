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

    typealias Dependencies = HasTripsStore & HasPlacesStore
    private let dependencies: Dependencies
    private let initialTrip: Trip
    
    init(dependencies: Dependencies, trip: Trip) {
        self.dependencies = dependencies
        self.initialTrip = trip
    }
    
    
    
    // MARK: - Input
    func addLocation(_ tapped: Observable<Void>) -> Disposable {
        tapped
            .withLatestFrom(trip)
            .subscribe(onNext: { [weak self] trip in
                self?.coordinator?
                    .searchLocation(completion: { location in
                        self?.dependencies.placesStore.add(location, to: trip)
                    })
            })
    }
    
    
    // MARK: - Output
    lazy var trip: Driver<Trip> = {
        dependencies.tripsStore
            .trip(identifiedBy: .just(initialTrip.id))
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: initialTrip)
    }()
    
    lazy var addedPlaces: Driver<[AddedPlaceItem]> = {
        dependencies.placesStore
            .addedPlaces(for: .just(initialTrip.id))
            .asDriver(onErrorJustReturn: [])
    }()
    
}
