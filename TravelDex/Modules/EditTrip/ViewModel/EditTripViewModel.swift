//
//  EditTripViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class EditTripViewModel: EditTripViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    private let tripId: TripID?
    
    init(dependencies: Dependencies, tripId: TripID? = nil) {
        self.dependencies = dependencies
        self.tripId = tripId
    }
    
    
    func update(_ trip: Observable<Trip>) -> Disposable {
        let coordinatorAction = trip
            .subscribe( onNext: { [weak self] trip in self?.coordinator?.didUpdate(trip) })
        let storeAction = dependencies.tripsStore
            .update(trip)
        return Disposables.create {
            coordinatorAction.dispose()
            storeAction.dispose()
        }
    }
    
    lazy var trip: Driver<Trip?> = {
        if let tripId = tripId {
            return dependencies.tripsStore.trip(identifiedBy: .just(tripId))
                .asDriver(onErrorJustReturn: nil)
        } else {
            return .just(nil)
        }
    }()
    
    lazy var confirmButtonTitle: Driver<String> = {
        if let tripId = tripId {
            return .just("Update Trip")
        } else {
            return .just("Add Trip")
        }
    }()
    
}