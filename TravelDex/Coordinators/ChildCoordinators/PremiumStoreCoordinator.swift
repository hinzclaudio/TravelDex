//
//  PremiumStoreCoordinator.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.09.22.
//

import UIKit



class PremiumStoreCoordinator: CoordinatorType {
    
    typealias Dependencies = HasSKStore
    private let dependencies: Dependencies
    
    var childCoordinators = [CoordinatorType]()
    var navigationController: UINavigationController
    
    init(
        dependencies: Dependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    
    func start() {
        let viewModel = PremiumStoreViewModel(dependencies: dependencies)
        viewModel.coordinator = self
        let controller = PremiumStoreController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: false)
    }
    
    func displayInfo() {
        // TODO: Implement.
    }
    
}

