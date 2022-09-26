//
//  EditTripViewModelTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import XCTest
@testable import TravelDex



class EditTripViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var mockCoordinator: MockAppCoordinator!
    var viewModel: EditTripViewModelType!
    
    let someTrip = Trip(
        id: TripID(),
        title: "Mocked Title",
        visitedLocations: [],
        pinColorRed: Trip.defaultPinColorRed,
        pinColorGreen: Trip.defaultPinColorGreen,
        pinColorBlue: Trip.defaultPinColorBlue
    )
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.mockCoordinator = MockAppCoordinator()
        self.viewModel = EditTripViewModel(
            dependencies: mockDependencies,
            coordinator: mockCoordinator
        )
    }
    
    
    func testUpdateTripIsForwardedToStore() throws {
        let _ = viewModel.update(.just(someTrip))
        XCTAssertTrue(mockDependencies.mockTripStore.updateTripCalled)
    }
    
}
