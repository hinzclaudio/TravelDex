//
//  LocationSearchCoordinator.swift
//  TravelDex
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
        let viewModel = LocationSearchViewModel(dependencies: dependencies)
        viewModel.coordinator = self
        let controller = LocationSearchController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: false)
    }
    
    func manualEntry(for coordinate: Coordinate) {
        let viewModel = LocationEntryViewModel(dependencies: dependencies, coordinate: coordinate)
        viewModel.coordinator = self
        let controller = LocationEntryController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func select(_ location: Location) {
        selectionHandler(location)
        navigationController.dismiss(animated: true)
    }
    
}
