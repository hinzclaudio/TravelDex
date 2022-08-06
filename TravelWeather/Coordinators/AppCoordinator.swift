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
        let viewModel = AddTripViewModel(dependencies: dependencies)
        viewModel.coordinator = self
        let controller = AddTripController(viewModel: viewModel)
        let modalContainer = ModalNavigationContainer(rootViewController: controller)
        
        GeneralStyleManager.styleModal(modalContainer.navigationBar)
        
        modalContainer.modalPresentationStyle = .automatic
        navigationController.present(modalContainer, animated: true)
        modalController = modalContainer
    }
    
    
    func didAdd(_ trip: Trip) {
        modalController?.dismiss(animated: true)
    }
    
}
