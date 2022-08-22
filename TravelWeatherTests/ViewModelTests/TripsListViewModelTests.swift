//
//  TripsListViewModelTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import XCTest
@testable import TravelWeather



class TripsListViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: TripsListViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = TripsListVieModel(dependencies: mockDependencies)
    }
    
    
    func testTripsForSearchIsForwardedFromStore() throws {
        let trips = try viewModel
            .trips(for: .just(""))
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(trips)
        XCTAssertTrue(mockDependencies.mockTripStore.tripsForSearchCalled)
    }
    
}
