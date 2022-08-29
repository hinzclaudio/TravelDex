//
//  ColorSelectionViewModelTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 28.08.22.
//

import Foundation
import XCTest
@testable import TravelWeather



class ColorSelectionViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: ColorSelectionViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = ColorSelectionViewModel(
            dependencies: mockDependencies,
            trip: Trip(
                id: TripID(),
                title: "Mocked Trip",
                visitedLocations: [],
                pinColorRed: Trip.defaultPinColorRed,
                pinColorGreen: Trip.defaultPinColorGreen,
                pinColorBlue: Trip.defaultPinColorBlue
            )
        )
    }
    
    
    func testTripIsUpdatedByStore() throws {
        let _ = try viewModel.trip
            .toBlocking(timeout: 5)
            .first()
        XCTAssertTrue(mockDependencies.mockTripStore.tripIdentifiedByCalled)
    }
    
    func testAvailableColorsIsNonEmpty() throws {
        let colors = try viewModel.availableColors
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(colors)
        XCTAssertFalse(colors?.isEmpty ?? true)
    }
    
    func testSelectionForwardsToStore() throws {
        let _ = viewModel.select(.just(.green))
        XCTAssertTrue(mockDependencies.mockTripStore.updateTripCalled)
    }
    
}
