//
//  TripsListViewModelTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxBlocking
import XCTest
@testable import TravelDex



class TripsListViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var mockCoordinator: MockAppCoordinator!
    var viewModel: TripsListViewModelType!
    
    let someTrip = Trip(
        id: TripID(),
        title: "",
        visitedLocations: [],
        pinColorRed: Trip.defaultPinColorRed,
        pinColorGreen: Trip.defaultPinColorGreen,
        pinColorBlue: Trip.defaultPinColorBlue
    )
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.mockCoordinator = MockAppCoordinator()
        self.viewModel = TripsListViewModel(
            dependencies: mockDependencies,
            coordinator: mockCoordinator
        )
        viewModel.onDidLoad()
    }
    
    
    func testTripsForSearchIsForwardedFromStore() throws {
        let trips = try viewModel
            .trips(for: .just(""))
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(trips)
        XCTAssertTrue(mockDependencies.mockTripStore.tripsForSearchCalled)
    }
    
    func testDeleteTripsIsForwardedToStore() throws {
        viewModel.deleteTrip.accept(someTrip)
        XCTAssertTrue(mockDependencies.mockTripStore.deleteTripCalled)
    }
    
    func testExportIsForwardedToStoreIfPremiumEnabled() throws {
        mockDependencies.mockSkStore.enablePremium.accept(true)
        viewModel.exportTrip.accept(someTrip)
        sleep(1)
        XCTAssertTrue(mockDependencies.mockTripStore.exportTripCalled)
    }
    
    func testExportIsNotForwardedToStoreIfPremiumDisabled() throws {
        mockDependencies.mockSkStore.enablePremium.accept(false)
        viewModel.exportTrip.accept(someTrip)
        XCTAssertFalse(mockDependencies.mockTripStore.exportTripCalled)
    }
    
    func testExportProducesErrorIfPremiumDisabled() throws {
        mockDependencies.mockSkStore.enablePremium.accept(false)
        viewModel.exportTrip.accept(someTrip)
        let errorAlert = try viewModel.errorController
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(errorAlert)
    }
    
    
    // MARK: - Routing Tests
    func testStoreTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.selectStoreCalled)
        viewModel.storeTapped.accept(())
        XCTAssertTrue(mockCoordinator.selectStoreCalled)
    }
    
    func testMapTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.displayMapCalled)
        viewModel.mapTapped.accept(())
        XCTAssertTrue(mockCoordinator.displayMapCalled)
    }
    
    func testAddTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.goToAddTripCalled)
        viewModel.addTapped.accept(())
        XCTAssertTrue(mockCoordinator.goToAddTripCalled)
    }
    
    func testSelectTripCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.selectTripCalled)
        viewModel.selectTrip.accept(someTrip)
        XCTAssertTrue(mockCoordinator.selectTripCalled)
    }
    
    func testEditTripCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.editTripCalled)
        viewModel.editTrip.accept(someTrip)
        XCTAssertTrue(mockCoordinator.editTripCalled)
    }
    
    func testPickColorCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.pickColorForTripCalled)
        viewModel.pickColorForTrip.accept(someTrip)
        XCTAssertTrue(mockCoordinator.pickColorForTripCalled)
    }
    
}
