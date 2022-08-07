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
    
    typealias Dependencies = HasLocationsStore
    private let dependencies: Dependencies
    private let bag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    func searchResults(for query: Observable<String>) -> Driver<[Location]> {
        dependencies.locationsStore
            .updateLocations(with: query)
            .disposed(by: bag)
        
        return dependencies.locationsStore
            .locations(for: query)
            .asDriver(onErrorJustReturn: [])
    }
    
}
