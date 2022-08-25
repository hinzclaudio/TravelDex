//
//  LocationSearchViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit



class LocationSearchViewModel: LocationSearchViewModelType {
    
    weak var coordinator: AppCoordinator?
    let selection: (Location) -> Void
    
    typealias Dependencies = HasLocationsStore
    private let dependencies: Dependencies
    private let bag = DisposeBag()
    
    init(dependencies: Dependencies, selection: @escaping (Location) -> Void) {
        self.dependencies = dependencies
        self.selection = selection
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
        let addLocationAction = dependencies.locationsStore
            .add(location)
        
        let selectionAction = location
            .subscribe(onNext: { [weak self] in self?.selection($0) })
        
        return Disposables.create {
            addLocationAction.dispose()
            selectionAction.dispose()
        }
    }
    
}
