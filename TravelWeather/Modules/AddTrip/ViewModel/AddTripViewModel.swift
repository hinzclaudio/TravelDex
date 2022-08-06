//
//  AddTripViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



class AddTripViewModel: AddTripViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    func add(_ trip: Observable<Trip>) -> Disposable {
        let coordinatorAction = trip.subscribe(
            onNext: { [weak self] trip in self?.coordinator?.didAdd(trip) })
        let storeAction = dependencies.tripsStore
            .addTrip(trip)
        return Disposables.create {
            coordinatorAction.dispose()
            storeAction.dispose()
        }
    }
    
}
