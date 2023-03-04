//
//  ShareCoordinator.swift
//  TravelDex
//
//  Created by Claudio Hinz on 11.03.23.
//

import UIKit
import RxSwift
import RxCocoa



class ShareCoordinator: CoordinatorType {
    
    typealias Dependencies = HasCKStore & HasTripsStore
    private let dependencies: Dependencies
    private let trip: Trip
    
    public var childCoordinators = [CoordinatorType]()
    public var navigationController: UINavigationController
    
    init(dependencies: Dependencies, navigationController: UINavigationController, trip: Trip) {
        self.dependencies = dependencies
        self.navigationController = navigationController
        self.trip = trip
    }
    
    
    public func start() {
        let viewModel = ShareOverviewViewModel(dependencies: dependencies, coordinator: self, tripId: trip.id)
        let controller = ShareOverviewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: false)
    }
    
}
