//
//  LocationSearchViewModel.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit



class LocationSearchViewModel: LocationSearchViewModelType {
    
    weak var coordinator: LocationSearchCoordinator?
    
    typealias Dependencies = HasLocationsStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    lazy var errorController: Driver<UIAlertController> = {
        dependencies.locationsStore.error
            .map { error in InfoManager.defaultErrorInfo(for: error) }
            .asDriver(onErrorJustReturn: InfoManager.makeFallbackErrorController())
    }()
    
    func annotations(for query: Observable<String>) -> Driver<[MKAnnotation]> {
        dependencies.locationsStore
            .locations(for: query)
            .map { locations in locations.map { LocationSearchAnnotation(loc: $0) } }
            .asDriver(onErrorJustReturn: [])
    }
    
    func select(_ location: Observable<Location>) -> Disposable {
        location
            .subscribe(onNext: { [weak self] in self?.coordinator?.select($0) })
    }
    
    func longPress(_ coordinate: Observable<Coordinate>) -> Disposable {
        coordinate
            .subscribe(onNext: { [weak self] in self?.coordinator?.manualEntry(for: $0) })
    }
    
}
