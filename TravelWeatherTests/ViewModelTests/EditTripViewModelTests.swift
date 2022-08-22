//
//  EditTripViewModelTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import XCTest
@testable import TravelWeather



class EditTripViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: EditTripViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = EditTripViewModel(dependencies: mockDependencies)
    }
    
    
    func testUpdateTripIsForwardedToStore() throws {
        let mockTrip = Trip(id: TripID(), title: "Mocked Title", visitedLocations: [])
        let _ = viewModel.update(.just(mockTrip))
        XCTAssertTrue(mockDependencies.mockTripStore.addTripCalled)
    }
    
}
