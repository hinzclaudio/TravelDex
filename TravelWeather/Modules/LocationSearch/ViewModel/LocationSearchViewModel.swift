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
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    
    // MARK: - Input
    
    
    
    // MARK: - Output
    
}
