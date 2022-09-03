//
//  LocationsDisplayViewModelTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import XCTest
@testable import TravelDex



class LocationsDisplayViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: LocationDisplayViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = TripLocationDisplayViewModel(
            dependencies: mockDependencies,
            tripId: TripID()
        )
    }
    
    
    func testControllerTitleReturnsTripTitleFromStore() throws {
        let controllerTitle = try viewModel.controllerTitle
            .toBlocking(timeout: 5)
            .first()
        XCTAssertEqual(controllerTitle, "Mocked Trip")
        XCTAssertTrue(mockDependencies.mockTripStore.tripIdentifiedByCalled)
    }
    
    func testAnnotationsIsUpdatedFromStore() throws {
        let annotations = try viewModel.annotations
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(annotations)
        XCTAssertTrue(mockDependencies.mockPlacesStore.placesForTripCalled)
    }
    
}
