//
//  LocationSearchCoordinator.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 27.08.22.
//

import UIKit



class LocationSearchCoordinator: CoordinatorType {
    
    typealias Dependencies = HasLocationsStore
    private let dependencies: Dependencies
    private let selectionHandler: (Location) -> Void
    
    var childCoordinators = [CoordinatorType]()
    var navigationController: UINavigationController
    
    init(
        dependencies: Dependencies,
        navigationController: UINavigationController,
        selectionHandler: @escaping (Location) -> Void
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
        self.selectionHandler = selectionHandler
    }
    
    
    func start() {
        
    }
    
}
