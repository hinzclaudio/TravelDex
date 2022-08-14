//
//  LocationSearchViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift
import RxCocoa



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
    
    
    func searchResults(for query: Observable<String>) -> Driver<[Location]> {
        let search = query
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
        return dependencies.locationsStore
            .locations(for: search, bag: bag)
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
