//
//  TripsListViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift
import RxCocoa



class TripsListViewModel: NSObject, TripsListViewModelType {
    
    weak var coordinator: AppCoordinatorType?
    
    typealias Dependencies = HasTripsStore & HasSKStore
    let dependencies: Dependencies
    
    init(dependencies: Dependencies, coordinator: AppCoordinatorType) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        super.init()
    }
    
    
    
    // MARK: - Input
    func storeTapped(_ tap: Observable<Void>) -> Disposable {
        tap
            .subscribe(onNext: { [weak self] in self?.coordinator?.selectStore() })
    }
    
    func mapTapped(_ tap: Observable<Void>) -> Disposable {
        tap
            .subscribe(onNext: { [weak self] in self?.coordinator?.displayMap() })
    }
    
    func addTapped(_ tap: Observable<Void>) -> Disposable {
        coordinator?.goToAddTrip(when: tap) ?? Disposables.create()
    }
    
    func importTapped(_ tap: Observable<Void>) -> Disposable {
        coordinator?.goToImportTrip(self, when: tap) ?? Disposables.create()
    }
    
    func export(_ trip: Observable<Trip>) -> Disposable {
        let exportFile = trip
            .withLatestFrom(dependencies.skStore.premiumFeaturesEnabled) { ($0, $1) }
            .flatMapLatest { [unowned self] trip, premiumEnabled in
                if premiumEnabled {
                    return self.dependencies.tripsStore
                        .export(trip)
                        .materialize()
                } else {
                    return Observable
                        .create { observer in
                            observer.onError(PremiumStoreError.premiumFeaturesUnavailable)
                            return Disposables.create()
                        }
                        .materialize()
                }
            }
            .do(onNext: { [weak self] in self?._errors.accept($0.error) })
            .compactMap(\.element)
        return coordinator?.share(exportAt: exportFile) ?? Disposables.create()
    }
    
    func select(_ trip: Observable<Trip>) -> Disposable {
        trip
            .subscribe(onNext: { [weak self] in self?.coordinator?.select($0) })
    }
    
    func edit(_ trip: Observable<Trip>) -> Disposable {
        trip
            .subscribe(onNext: { [weak self] in self?.coordinator?.edit($0) })
    }
    
    func pickColor(for trip: Observable<Trip>) -> Disposable {
        coordinator?.pickColor(for: trip) ?? Disposables.create()
    }
    
    func delete(_ trip: Observable<Trip>) -> Disposable {
        dependencies.tripsStore
            .delete(trip)
    }
    
    
    
    // MARK: - Output
    func trips(for search: Observable<String>) -> Driver<[Trip]> {
        search
            .flatMapLatest { [unowned self] query in
                self.dependencies.tripsStore.trips(forSearch: query)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    lazy var tripsIsEmpty: Driver<Bool> = {
        dependencies.tripsStore.trips(forSearch: "")
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
    }()
    
    let _errors = BehaviorRelay<Error?>(value: nil)
    lazy var errorController: Driver<UIAlertController> = {
        _errors
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .map(InfoManager.defaultErrorInfo(for:))
    }()
    
}
