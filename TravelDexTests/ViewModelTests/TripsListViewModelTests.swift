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
        let _ = viewModel.delete(.just(someTrip))
        XCTAssertTrue(mockDependencies.mockTripStore.deleteTripCalled)
    }
    
    func testExportIsForwardedToStoreIfPremiumEnabled() throws {
        mockDependencies.mockSkStore.enablePremium = true
        let _ = viewModel.export(.just(someTrip))
        sleep(1)
        XCTAssertTrue(mockDependencies.mockTripStore.exportTripCalled)
    }
    
    func testExportIsNotForwardedToStoreIfPremiumDisabled() throws {
        mockDependencies.mockSkStore.enablePremium = false
        let _ = viewModel.export(.just(someTrip))
        XCTAssertFalse(mockDependencies.mockTripStore.exportTripCalled)
    }
    
    func testExportProducesErrorIfPremiumDisabled() throws {
        mockDependencies.mockSkStore.enablePremium = false
        let _ = viewModel.export(.just(someTrip))
        let errorAlert = try viewModel.errorController
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(errorAlert)
    }
    
    
    // MARK: - Routing Tests
    func testStoreTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.selectStoreCalled)
        let _ = viewModel.storeTapped(.just(()))
        XCTAssertTrue(mockCoordinator.selectStoreCalled)
    }
    
    func testMapTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.displayMapCalled)
        let _ = viewModel.mapTapped(.just(()))
        XCTAssertTrue(mockCoordinator.displayMapCalled)
    }
    
    func testAddTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.goToAddTripCalled)
        let _ = viewModel.addTapped(.just(()))
        XCTAssertTrue(mockCoordinator.goToAddTripCalled)
    }
    
    func testSelectTripCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.selectTripCalled)
        let _ = viewModel.select(.just(someTrip))
        XCTAssertTrue(mockCoordinator.selectTripCalled)
    }
    
    func testEditTripCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.editTripCalled)
        let _ = viewModel.edit(.just(someTrip))
        XCTAssertTrue(mockCoordinator.editTripCalled)
    }
    
    func testPickColorCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.pickColorForTripCalled)
        let _ = viewModel.pickColor(for: .just(someTrip))
        XCTAssertTrue(mockCoordinator.pickColorForTripCalled)
    }
    
}
