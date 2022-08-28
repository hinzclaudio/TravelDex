//
//  LocationEntryViewModelTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 28.08.22.
//

import Foundation
import XCTest
@testable import TravelWeather



class LocationEntryViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: LocationEntryViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = LocationEntryViewModel(
            dependencies: mockDependencies,
            coordinate: MockLocationAPI.hamburg.coordinate
        )
    }
    
    
    func testTitleIsAutofilledByStore() throws {
        let title = try viewModel.title
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertTrue(title == "Hamburg")
    }
    
    func testRegionIsAutofilledByStore() throws {
        let region = try viewModel.region
            .filter { !($0?.isEmpty ?? true) }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertTrue(region == "Hamburg")
    }
    
    func testCountryIsAutofilledByStore() throws {
        let country = try viewModel.country
            .filter { !($0?.isEmpty ?? true) }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertTrue(country == "Germany")
    }
    
    func testSnapshotDoesReturnImage() throws {
        let snapshot = try viewModel.snapshot
            .compactMap { $0 }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(snapshot)
    }
    
    func testDoesAddNewLocOnConfirm() throws {
        // Wait for autocomplete
        let _ = try viewModel.title
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        let _ = viewModel
            .confirm(.just(()))
        XCTAssertTrue(mockDependencies.mockLocationsStore.addLocationCalled)   
    }

}
