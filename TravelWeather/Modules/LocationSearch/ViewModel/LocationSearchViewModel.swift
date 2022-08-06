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
        let apiResults = query
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
        
        return .just([])
    }
    
}
