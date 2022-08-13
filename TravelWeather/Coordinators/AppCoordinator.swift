//
//  AppCoordinator.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import PhotosUI



class AppCoordinator: CoordinatorType {
    
    let window: UIWindow?
    var childCoordinators = [CoordinatorType]()
    var navigationController: UINavigationController = BaseNavigationController()
    weak var modalController: UIViewController?
    private var pickerViewModel: PhotoPickerViewModelType?
    
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
    
    
    func displayMap(for trip: Trip) {
        let vm = TripLocationDisplayViewModel(dependencies: dependencies, tripId: trip.id)
        presentMap(for: vm)
    }
    
    
    func displayMap(for visitedPlace: VisitedPlace) {
        let vm = PlaceDisplayViewModel(dependencies: dependencies, visitedPlaceId: visitedPlace.id)
        presentMap(for: vm)
    }
    
    
    func displayMap() {
        let vm = AllPlacesDisplayViewModel(dependencies: dependencies)
        presentMap(for: vm)
    }
    
    
    func pickPhoto(_ viewModel: PhotoPickerViewModelType, for visitedPlace: VisitedPlace) {
        let controller = PHPickerViewController(configuration: viewModel.configuration)
        controller.delegate = viewModel
        modalController = controller
        navigationController.present(controller, animated: true)
    }
    
    
    private func presentMap(for viewModel: LocationDisplayViewModelType) {
        let controller = LocationDisplayController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    
    private func presentModally(_ viewController: UIViewController) {
        let modalContainer = ModalNavigationContainer(rootViewController: viewController)
        GeneralStyleManager.styleModal(modalContainer.navigationBar)
        modalContainer.modalPresentationStyle = .automatic
        navigationController.present(modalContainer, animated: true)
        modalController = modalContainer
    }
    
}
