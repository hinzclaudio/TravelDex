//
//  MockAppCoordinator.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 26.09.22.
//

import UIKit
import RxSwift
@testable import TravelDex



class MockAppCoordinator: AppCoordinatorType {
    
    var childCoordinators = [CoordinatorType]()
    var navigationController = UINavigationController()
    
    private(set) var startCalled = false
    func start() {
        startCalled = true
    }
    
    private(set) var selectStoreCalled = false
    func selectStore() {
        selectStoreCalled = true
    }
    
    private(set) var commentOnItemCalled = false
    func comment(on item: AddedPlaceItem) {
        commentOnItemCalled = true
    }
    
    private(set) var importForFileAtCalled = false
    func handle(importForFileAt url: URL, inPlace: Bool) -> Disposable {
        importForFileAtCalled = true
        return Disposables.create()
    }
    
    private(set) var dismissModalControllerCalled = false
    func dismissModalController() {
        dismissModalControllerCalled = true
    }
    
    private(set) var pickPhotoForPlaceCalled = false
    func pickPhoto(_ viewModel: PhotoPickerViewModelType, for visitedPlace: VisitedPlace) {
        pickPhotoForPlaceCalled = true
    }
    
    private(set) var photoViewerFromViewCalled = false
    func photoViewer(from view: UIImageView?, image: UIImage?) {
        photoViewerFromViewCalled = true
    }
    
    private(set) var goToAddTripCalled = false
    func goToAddTrip(when tapped: Observable<Void>) -> Disposable {
        tapped
            .subscribe(onNext: { [weak self] in self?.goToAddTripCalled = true })
    }
    
    private(set) var goToImportTripCalled = false
    func goToImportTrip(_ viewModel: TripsListViewModelType, when tapped: Observable<Void>) -> Disposable {
        tapped
            .subscribe(onNext: { [weak self] in self?.goToImportTripCalled = true })
    }
    
    private(set) var shareExportAtCalled = false
    func share(exportAt url: Observable<URL>) -> Disposable {
        url
            .subscribe(onNext: { [weak self] _ in self?.shareExportAtCalled = true })
    }
    
    private(set) var didUpdateTripCalled = false
    func didUpdate(_ trip: Trip) {
        didUpdateTripCalled = true
    }
    
    private(set) var selectTripCalled = false
    func select(_ trip: Trip) {
        selectTripCalled = true
    }
    
    private(set) var editTripCalled = false
    func edit(_ trip: Trip) {
        editTripCalled = true
    }
    
    private(set) var pickColorForTripCalled = false
    func pickColor(for trip: Observable<Trip>) -> Disposable {
        trip
            .subscribe(onNext: { [weak self] _ in self?.pickColorForTripCalled = true })
    }
    
    private(set) var searchLocationForTripCalled = false
    func searchLocation(for trip: Observable<Trip>) -> Disposable {
        trip
            .subscribe(onNext: { [weak self] _ in self?.searchLocationForTripCalled = true })
    }
    
    private(set) var displayMapForTripCalled = false
    func displayMap(for trip: Trip) {
        displayMapForTripCalled = true
    }
    
    private(set) var displayMapforPlaceCalled = false
    func displayMap(for visitedPlace: VisitedPlace) {
        displayMapforPlaceCalled = true
    }
    
    private(set) var displayMapCalled = false
    func displayMap() {
        displayMapCalled = true
    }
    
}
