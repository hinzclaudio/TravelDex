//
//  AppCoordinatorTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 11.09.22.
//

import UIKit
import XCTest
import PhotosUI
@testable import TravelDex



class AppCoordinatorTests: XCTestCase {
    
    var dependencies: MockDependencies!
    var coordinator: AppCoordinatorType!
    
    var allViewControllers: [UIViewController] {
        let baseControllers = coordinator.navigationController.viewControllers
        let modalController = (coordinator as? AppCoordinator)?.modalController
        if let modalContainer = modalController as? UINavigationController {
            return baseControllers + modalContainer.viewControllers
        } else {
            return baseControllers + [modalController].compactMap { $0 }
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.dependencies = MockDependencies()
        let appCoordinator = AppCoordinator(window: nil, dependencies: dependencies)
        appCoordinator.start()
        // Pushing viewcontrollers must happen non-animated for synchronous testing to work...
        appCoordinator.animationsEnabled = false
        self.coordinator = appCoordinator
    }
    
    
    func testStartViewControllerIsTripsListController() throws {
        let navController = coordinator.navigationController
        XCTAssertTrue(navController.viewControllers.first is TripsListController)
    }
    
    func testSelectStoreStartsStoreCoordinator() {
        coordinator.selectStore()
        let childCoordinator = coordinator.childCoordinators
            .first(where: { $0 is PremiumStoreCoordinator })
        XCTAssertNotNil(childCoordinator)
    }
    
    func testCommentOnPlacePresentsCommentViewController() {
        coordinator.comment(on: mockPlaceItem)
        let commentControllerExists = allViewControllers
            .contains(where: { $0 is AddPlacesCommentController })
        XCTAssertTrue(commentControllerExists)
    }
    
    func pickPhotoPresentsPHPicker() {
        coordinator.pickPhoto(MockPhotoPickerViewModel(), for: mockPlace)
        let photoPickerExists = allViewControllers
            .contains(where: { $0 is PHPickerViewController })
        XCTAssertTrue(photoPickerExists)
    }
    
    func testGoToAddTripPresentsEditTripController() {
        coordinator.goToAddTrip()
        let editTripExists = allViewControllers
            .contains(where: { $0 is EditTripController })
        XCTAssertTrue(editTripExists)
    }
    
    func testEditTripPresentsEditTripController() {
        coordinator.edit(mockTrip)
        let editTripExists = allViewControllers
            .contains(where: { $0 is EditTripController })
        XCTAssertTrue(editTripExists)
    }
    
    func testSelectTripPresentsAddPlaces() {
        coordinator.select(mockTrip)
        let addPlacesExists = allViewControllers
            .contains(where: { $0 is AddPlacesController })
        XCTAssertTrue(addPlacesExists)
    }
    
    func testDisplayMapPresentLocationDisplayController() {
        coordinator.displayMap()
        let locDisplayExists = allViewControllers
            .contains(where: { $0 is LocationDisplayController })
        XCTAssertTrue(locDisplayExists)
    }
    
    func testDisplayMapForPlaceDisplayController() {
        coordinator.displayMap(for: mockPlace)
        let locDisplayExists = allViewControllers
            .contains(where: { $0 is LocationDisplayController })
        XCTAssertTrue(locDisplayExists)
    }
    
    func testDisplayMapForTripDisplayController() {
        coordinator.displayMap(for: mockTrip)
        let locDisplayExists = allViewControllers
            .contains(where: { $0 is LocationDisplayController })
        XCTAssertTrue(locDisplayExists)
    }
    
    func testPickColorUnavailableIfNotPremium() throws {
        dependencies.mockSkStore.enablePremium = false
        let _ = coordinator.pickColor(for: .just(mockTrip))
        let colorSelectionExists = allViewControllers
            .contains(where: { $0 is ColorSelectionController })
        XCTAssertFalse(colorSelectionExists)
    }
    
    func testPickColorAvailableIfPremium() throws {
        dependencies.mockSkStore.enablePremium = true
        let _ = coordinator.pickColor(for: .just(mockTrip))
        let colorSelectionExists = allViewControllers
            .contains(where: { $0 is ColorSelectionController })
        XCTAssertTrue(colorSelectionExists)
    }
    
    func testSearchLocationAvailableForNonPremium() throws {
        dependencies.mockSkStore.enablePremium = false
        let trip = mockTrip.cloneBuilder()
            .with(visitedLocations: [UUID(), UUID(), UUID()])
            .build()! // Non-premium users are allowed a maximum of 5 locations per trip, so one more is ok.
        let _ = coordinator.searchLocation(for: .just(trip))
        let addLocExists = allViewControllers
            .contains(where: { $0 is LocationSearchController })
        XCTAssertTrue(addLocExists)
    }
    
    func testSearchLocationUnavailableForNonPremiumWithLimitReached() throws {
        dependencies.mockSkStore.enablePremium = false
        let trip = mockTrip.cloneBuilder()
            .with(visitedLocations: [UUID(), UUID(), UUID(), UUID(), UUID()])
            .build()! // Non-premium users are allowed a maximum of 5 locations per trip
        let _ = coordinator.searchLocation(for: .just(trip))
        let addLocExists = allViewControllers
            .contains(where: { $0 is LocationSearchController })
        XCTAssertFalse(addLocExists)
    }
    
    func testSearchLocationAvailableIfPremium() throws {
        dependencies.mockSkStore.enablePremium = true
        let trip = mockTrip.cloneBuilder()
            .with(visitedLocations: [UUID(), UUID(), UUID(), UUID(), UUID()])
            .build()! // Non-premium users are allowed a maximum of 5 locations per trip
        let _ = coordinator.searchLocation(for: .just(trip))
        let addLocExists = allViewControllers
            .contains(where: { $0 is LocationSearchController })
        XCTAssertTrue(addLocExists)
    }
    
    
    
    // MARK: - Helper
    var mockTrip: Trip {
        Trip(
            id: TripID(),
            title: "",
            visitedLocations: [],
            pinColorRed: Trip.defaultPinColorRed,
            pinColorGreen: Trip.defaultPinColorGreen,
            pinColorBlue: Trip.defaultPinColorBlue
        )
    }
    
    var mockPlace: VisitedPlace {
        VisitedPlace(
            id: VisitedPlaceID(),
            start: .now,
            end: .now,
            tripId: TripID(),
            locationId: LocationID()
        )
    }
    
    var mockPlaceItem: AddedPlaceItem {
        AddedPlaceItem(
            visitedPlace: VisitedPlace(
                id: VisitedPlaceID(),
                start: .now,
                end: .now,
                tripId: TripID(),
                locationId: LocationID()
            ),
            location: MockLocationAPI
                .hamburg,
            pinColor: Trip
                .defaultPinColor
        )
    }
    
}
