//
//  TripsListViewModel.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import RxSwift



class TripsListVieModel: TripsListViewModelType {
    
    weak var coordinator: AppCoordinator?
    
    typealias Dependencies = HasTripsStore
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    
    // MARK: - Input
    func addTapped(_ tap: Observable<Void>) -> Disposable {
        tap.subscribe(
            onNext: { [weak self] in self?.coordinator?.goToAddTrip() }
        )
    }
    
    

    // MARK: - Output
    
    
    
}
