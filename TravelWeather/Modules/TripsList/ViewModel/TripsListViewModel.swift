//
//  TripsListViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class TripsListVieModel: TripsListViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    
    // MARK: - Input
    func mapTapped(_ tap: Observable<Void>) -> Disposable {
        tap
            .subscribe(onNext: { [weak self] in self?.coordinator?.displayMap() })
    }
    
    func addTapped(_ tap: Observable<Void>) -> Disposable {
        tap
            .subscribe(onNext: { [weak self] in self?.coordinator?.goToAddTrip() })
    }
    
    func select(_ trip: Observable<Trip>) -> Disposable {
        trip
            .subscribe(onNext: { [weak self] in self?.coordinator?.select($0) })
    }
    
    func edit(_ trip: Observable<Trip>) -> Disposable {
        trip
            .subscribe(onNext: { [weak self] in self?.coordinator?.edit($0) })
    }
    
    func delete(_ trip: Observable<Trip>) -> Disposable {
        dependencies.tripsStore
            .delete(trip)
    }
    
    

    // MARK: - Output
    func trips(for search: Observable<String>) -> Driver<[Trip]> {
        search
            .flatMapLatest { [weak self] query in
                self?.dependencies.tripsStore.trips(forSearch: query) ?? .just([])
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func preview(for trip: Trip) -> UIViewController? {
        coordinator?.preview(for: trip)
    }
    
    
}
