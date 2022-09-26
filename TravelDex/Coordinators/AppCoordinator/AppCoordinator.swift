//
//  AppCoordinator.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import UIKit
import PhotosUI
import DTPhotoViewerController
import RxSwift



class AppCoordinator: AppCoordinatorType {
    
    let window: UIWindow?
    var childCoordinators = [CoordinatorType]()
    var navigationController: UINavigationController = BaseNavigationController()
    weak var modalController: UIViewController?
    private var pickerViewModel: PhotoPickerViewModelType?
    
    typealias Dependencies = AppDependencies
    private let dependencies: Dependencies
    var animationsEnabled = true
    
    init(window: UIWindow?, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }
    
    
    func start() {
        window?.rootViewController = navigationController
        navigationController.modalPresentationStyle = .automatic
        
        GeneralStyleManager.style(navigationController.navigationBar)
        let viewModel = TripsListViewModel(dependencies: dependencies, coordinator: self)
        let controller = TripsListController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: false)
    }
    
    
    func goToAddTrip(when tapped: Observable<Void>) -> Disposable {
        tapped
            .subscribe(onNext: { [unowned self] in
                let viewModel = EditTripViewModel(dependencies: self.dependencies, coordinator: self)
                let controller = EditTripController(viewModel: viewModel)
                self.modalController = self.presentModally(controller)
            })
    }
    
    
    func goToImportTrip(_ viewModel: TripsListViewModelType, when tapped: Observable<Void>) -> Disposable {
        tapped
            .withLatestFrom(dependencies.skStore.premiumFeaturesEnabled)
            .subscribe(onNext: { [unowned self, weak viewModel] premiumEnabled in
                if premiumEnabled {
                    let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
                    controller.allowsMultipleSelection = false
                    controller.delegate = viewModel
                    (self.modalController ?? self.navigationController)
                        .present(controller, animated: self.animationsEnabled)
                } else {
                    let info = InfoManager.makePremiumDisabledInfo()
                    (self.modalController ?? self.navigationController)
                        .present(info, animated: self.animationsEnabled)
                }
            })
    }
    
    
    func handle(importForFileAt url: Observable<URL>, inPlace: Bool) -> Disposable {
        url
            .withLatestFrom(dependencies.skStore.premiumFeaturesEnabled) { ($0, $1) }
            .flatMapLatest { [unowned self] fileURL, premiumEnabled in
                if premiumEnabled {
                    return self.dependencies.tripsStore
                        .importData(from: fileURL, inPlace: inPlace)
                } else {
                    throw PremiumStoreError.premiumFeaturesUnavailable
                }
            }
            .subscribe(
                onNext: { [weak self] trip in
                    self?.dismissModalController()
                    self?.navigationController.popToRootViewController(animated: self?.animationsEnabled ?? false)
                    self?.select(trip)
                },
                onError: { [weak self] error in
                    let alert = InfoManager.defaultErrorInfo(for: error)
                    (self?.modalController ?? self?.navigationController)?
                        .present(alert, animated: self?.animationsEnabled ?? false)
                }
            )
    }
    
    
    func share(exportAt url: Observable<URL>) -> Disposable {
        url
            .subscribe(onNext: { [weak self] fileURL in
                let controller = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                self?.modalController = controller
                (self?.navigationController ?? self?.modalController)?
                    .present(controller, animated: self?.animationsEnabled ?? false)
            })
    }
    
    
    func didUpdate(_ trip: Trip) {
        modalController?.dismiss(animated: animationsEnabled)
    }
    
    
    func select(_ trip: Trip) {
        let vm = AddPlacesViewModel(dependencies: dependencies, trip: trip, coordinator: self)
        let controller = AddPlacesController(viewModel: vm)
        navigationController.pushViewController(controller, animated: animationsEnabled)
    }
    
    
    func edit(_ trip: Trip) {
        let vm = EditTripViewModel(dependencies: dependencies, tripId: trip.id, coordinator: self)
        let controller = EditTripController(viewModel: vm)
        modalController = presentModally(controller)
    }
    
    
    func comment(on item: AddedPlaceItem) {
        let vm = AddPlacesCommentViewModel(dependencies: dependencies, item: item, coordinator: self)
        let controller = AddPlacesCommentController(viewModel: vm)
        modalController = presentBottomSheet(controller)
    }
    
    
    func selectStore() {
        let modalContainer = ModalNavigationContainer()
        GeneralStyleManager.styleModal(modalContainer.navigationBar)
        
        let coordinator = PremiumStoreCoordinator(
            dependencies: dependencies,
            navigationController: modalContainer
        )
        
        self.store(coordinator: coordinator)
        modalContainer.onDidDisappear = { [weak self, unowned coordinator] in
            self?.free(coordinator: coordinator)
        }
        coordinator.start()
        
        self.modalController = modalContainer
        self.navigationController.present(modalContainer, animated: animationsEnabled)
    }
    
    
    func searchLocation(for trip: Observable<Trip>) -> Disposable {
        trip.withLatestFrom(dependencies.skStore.premiumFeaturesEnabled) { ($0, $1) }
            .subscribe(onNext: { [unowned self] trip, premiumEnabled in
                let canAddPlaces = premiumEnabled || trip.visitedLocations.count < SKNonPremiumConfiguration.maxLocationsPerTrip
                if canAddPlaces {
                    let modalContainer = ModalNavigationContainer()
                    GeneralStyleManager.styleModal(modalContainer.navigationBar)
                    
                    let coordinator = LocationSearchCoordinator(
                        dependencies: dependencies,
                        navigationController: modalContainer,
                        selectionHandler: { location in
                            self.dependencies.placesStore.add(location, to: trip)
                        }
                    )
                    
                    self.store(coordinator: coordinator)
                    modalContainer.onDidDisappear = { [unowned coordinator] in
                        self.free(coordinator: coordinator)
                    }
                    coordinator.start()
                    
                    self.modalController = modalContainer
                    self.navigationController.present(modalContainer, animated: animationsEnabled)
                } else {
                    let info = InfoManager.makeNumberOfPlacesExhaustedInfo()
                    (self.modalController ?? self.navigationController).present(info, animated: animationsEnabled)
                }
            })
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
        navigationController.present(controller, animated: animationsEnabled)
    }
    
    
    func pickColor(for trip: Observable<Trip>) -> Disposable {
        trip
            .withLatestFrom(dependencies.skStore.premiumFeaturesEnabled) { ($0, $1) }
            .subscribe(onNext: { [unowned self] trip, premiumEnabled in
                if premiumEnabled {
                    let vm = ColorSelectionViewModel(
                        dependencies: self.dependencies,
                        trip: trip,
                        coordinator: self
                    )
                    let controller = ColorSelectionController(viewModel: vm)
                    self.modalController = presentModally(controller)
                } else {
                    let info = InfoManager.makePremiumDisabledInfo()
                    (self.modalController ?? self.navigationController).present(info, animated: animationsEnabled)
                }
            })
    }
    
    
    func photoViewer(from view: UIImageView?, image: UIImage?) {
        let controller = DTPhotoViewerController(referencedView: view, image: image)
        let presenter = modalController ?? navigationController
        presenter.present(controller, animated: animationsEnabled)
    }
    
    
    func dismissModalController() {
        modalController?.dismiss(animated: animationsEnabled)
    }
    
    
    private func presentMap(for viewModel: LocationDisplayViewModelType) {
        let controller = LocationDisplayController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: animationsEnabled)
    }

}
