//
//  AddPlacesViewModelTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import XCTest
@testable import TravelWeather



class AddPlacesViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var viewModel: AddPlacesViewModelType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.viewModel = AddPlacesViewModel(
            dependencies: mockDependencies,
            trip: Trip(
                id: TripID(),
                title: "Mocked Trip",
                visitedLocations: []
            )
        )
    }
    
    
    func testSetStartDateIsForwardedToStore() throws {
        viewModel
            .setStart(
                of: AddedPlaceItem(
                    visitedPlace: VisitedPlace(
                        id: VisitedPlaceID(),
                        start: .now.addingTimeInterval(-86400),
                        end: .now,
                        tripId: TripID(),
                        locationId: LocationID()
                    ),
                    location: MockLocationAPI
                        .hamburg
                ),
                to: .now
            )
        
        XCTAssertTrue(mockDependencies.mockPlacesStore.updateVisitedPlaceCalled)
    }
    
    func testSetEndDateIsForwardedToStore() throws {
        viewModel
            .setEnd(
                of: AddedPlaceItem(
                    visitedPlace: VisitedPlace(
                        id: VisitedPlaceID(),
                        start: .now.addingTimeInterval(-86400),
                        end: .now,
                        tripId: TripID(),
                        locationId: LocationID()
                    ),
                    location: MockLocationAPI
                        .hamburg
                ),
                to: .now
            )
        
        XCTAssertTrue(mockDependencies.mockPlacesStore.updateVisitedPlaceCalled)
    }
    
    func testTripIsUpdatedFromStore() throws {
        let trip = try viewModel.trip
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(trip)
        XCTAssertTrue(mockDependencies.mockTripStore.tripIdentifiedByCalled)
    }
    
    func testAddedPlacesIsUpdatedFromStore() throws {
        let addedPlaces = try viewModel.addedPlaces
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(addedPlaces)
        XCTAssertTrue(mockDependencies.mockPlacesStore.placesForTripCalled)
    }
    
    func testExpandedItemsEmptyInitially() throws {
        let expanded = try viewModel.expandedItems
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(expanded)
        XCTAssertEqual(expanded?.count, 0)
    }
    
    func testSetExpaneded() throws {
        let testId = VisitedPlaceID()
        viewModel.set(
            AddedPlaceItem(
                visitedPlace: VisitedPlace(
                    id: testId,
                    start: .now.addingTimeInterval(-86400),
                    end: .now,
                    tripId: TripID(),
                    locationId: LocationID()
                ),
                location: MockLocationAPI
                    .hamburg
            ),
            expanded: true
        )
        
        let expanded = try viewModel.expandedItems
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertEqual(expanded, [testId])
    }
    
    func testSetNotExpaneded() throws {
        let testId = VisitedPlaceID()
        viewModel.set(
            AddedPlaceItem(
                visitedPlace: VisitedPlace(
                    id: testId,
                    start: .now.addingTimeInterval(-86400),
                    end: .now,
                    tripId: TripID(),
                    locationId: LocationID()
                ),
                location: MockLocationAPI
                    .hamburg
            ),
            expanded: false
        )
        
        let expanded = try viewModel.expandedItems
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertEqual(expanded, [])
    }
    
}
