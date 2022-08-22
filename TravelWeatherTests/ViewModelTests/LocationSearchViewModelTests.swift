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
    var selectedLocations: BehaviorRelay<Location?>!
    var viewModel: LocationSearchViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.selectedLocations = BehaviorRelay(value: nil)
        self.viewModel = LocationSearchViewModel(
            dependencies: mockDependencies,
            selection: { [weak self] loc in self?.selectedLocations.accept(loc) }
        )
    }
    
    
    func testSelectLocationIsCalled() throws {
        let _ = viewModel
            .select(.just(MockLocationAPI.hamburg))
        let selection = try selectedLocations
            .compactMap { $0 }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(selection)
        XCTAssertEqual(selection, MockLocationAPI.hamburg)
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
