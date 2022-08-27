//
//  LocationSearchViewModelTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import XCTest
import RxRelay
@testable import TravelWeather



class LocationSearchViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: LocationSearchViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = LocationSearchViewModel(dependencies: mockDependencies)
    }
    
    
    func testSelectLocationIsAddedToStore() throws {
        let _ = viewModel
            .select(.just(MockLocationAPI.hamburg))
        XCTAssertTrue(mockDependencies.mockLocationsStore.addLocationCalled)
    }
    
    func testAnnotationsIsUpdatedFromStore() throws {
        let annotations = try viewModel.annotations(for: .just(""))
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(annotations)
        XCTAssertTrue(mockDependencies.mockLocationsStore.locationsForQueryCalled)
    }
    
    func testErrorsAreForwardedFromStore() throws {
        let alert = try viewModel.errorController
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(alert)
    }
    
}
