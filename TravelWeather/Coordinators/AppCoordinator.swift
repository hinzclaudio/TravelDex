//
//  AppCoordinator.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit



class AppCoordinator: CoordinatorType {
    
    let window: UIWindow?
    var childCoordinators = [CoordinatorType]()
    var navigationController: UINavigationController = BaseNavigationController()
    weak var modalController: UIViewController?
    
    typealias Dependencies = AppDependencies
    private let dependencies: Dependencies
    
    init(window: UIWindow?, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }
    
    
    func start() {
        window?.rootViewController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.modalPresentationStyle = .automatic
        
        GeneralStyleManager.style(navigationController.navigationBar)
        let viewModel = TripsListVieModel(dependencies: dependencies)
        let controller = TripsListController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(controller, animated: false)
    }
    
    
    func goToAddTrip() {
        let viewModel = EditTripViewModel(dependencies: dependencies)
        viewModel.coordinator = self
        let controller = EditTripController(viewModel: viewModel)
        presentModally(controller)
    }
    
    
    func didAdd(_ trip: Trip) {
        modalController?.dismiss(animated: true) { [weak self] in
            self?.select(trip)
        }
    }
    
    
    func select(_ trip: Trip) {
        let vm = AddPlacesViewModel(dependencies: dependencies, trip: trip)
        vm.coordinator = self
        let controller = AddPlacesController(viewModel: vm)
        navigationController.pushViewController(controller, animated: true)
    }
    
    
    func searchLocation(completion: @escaping (Location) -> Void) {
        let viewModel = LocationSearchViewModel(dependencies: dependencies) { [weak self] loc in
            self?.modalController?.dismiss(animated: true)
            completion(loc)
        }
        viewModel.coordinator = self
        let controller = LocationSearchController(viewModel: viewModel)
        presentModally(controller)
    }
    
    
    private func presentModally(_ viewController: UIViewController) {
        let modalContainer = ModalNavigationContainer(rootViewController: viewController)
        GeneralStyleManager.styleModal(modalContainer.navigationBar)
        modalContainer.modalPresentationStyle = .automatic
        navigationController.present(modalContainer, animated: true)
        modalController = modalContainer
        
    }
    
}
