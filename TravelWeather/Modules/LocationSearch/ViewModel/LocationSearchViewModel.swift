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
        dependencies.locationsStore
            .updateLocations(with: query)
            .disposed(by: bag)
        
        return dependencies.locationsStore
            .locations(for: query)
            .asDriver(onErrorJustReturn: [])
    }
    
    func select(_ location: Observable<Location>) -> Disposable {
        location
            .subscribe(onNext: { [weak self] in self?.selection($0) })
    }
    
}
