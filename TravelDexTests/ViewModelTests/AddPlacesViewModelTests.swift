//
//  AddPlacesViewModelTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import XCTest
@testable import TravelDex



class AddPlacesViewModelTests: XCTestCase {
    
    var mockDependencies: MockDependencies!
    var mockCoordinator: MockAppCoordinator!
    var viewModel: AddPlacesViewModelType!
    
    let someTrip = Trip(
        id: TripID(),
        title: "Mocked Trip",
        visitedLocations: [],
        pinColorRed: Trip.defaultPinColorRed,
        pinColorGreen: Trip.defaultPinColorGreen,
        pinColorBlue: Trip.defaultPinColorBlue
    )
    
    let somePlace = VisitedPlace(
        id: VisitedPlaceID(),
        start: .now.addingTimeInterval(-86400),
        end: .now,
        tripId: TripID(),
        location: Location(
            name: "Test Location",
            coordinate: Coordinate(latitude: 1, longitude: 2)
        )
    )
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.mockDependencies = MockDependencies()
        self.mockCoordinator = MockAppCoordinator()
        self.viewModel = AddPlacesViewModel(
            dependencies: mockDependencies,
            trip: someTrip,
            coordinator: mockCoordinator
        )
    }
    
    
    func testSetStartDateIsForwardedToStore() throws {
        viewModel
            .setStart(
                of: AddedPlaceItem(
                    visitedPlace: somePlace,
                    pinColor: Trip.defaultPinColor
                ),
                to: .now
            )
        
        XCTAssertTrue(mockDependencies.mockPlacesStore.updateVisitedPlaceCalled)
    }
    
    func testSetEndDateIsForwardedToStore() throws {
        viewModel
            .setEnd(
                of: AddedPlaceItem(
                    visitedPlace: somePlace,
                    pinColor: Trip.defaultPinColor
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
    
    func testViewModelReturnsOneAndOnlySection() throws {
        let sections = try viewModel.addedPlaces
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(sections)
        XCTAssertEqual(sections?.count, 1)
    }
    
    func testExpandedItemsEmptyInitially() throws {
        let countOfExpandedItems = try viewModel.addedPlaces
            .map { sections in
                sections.first?.items
                    .map { $0.expanded }
                    .filter { $0 }
                    .count ?? -1
            }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertEqual(countOfExpandedItems, 0)
    }
    
    func testSetExpanded() throws {
        let addedPlace = try viewModel.addedPlaces
            .map { $0.first?.items ?? [] }
            .compactMap { $0.first?.item }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(addedPlace)
        
        viewModel.set(addedPlace!, expanded: true)
        let expanded = try viewModel.addedPlaces
            .map { $0.first?.items ?? [] }
            .map { items in
                items
                    .filter { $0.expanded }
                    .map { $0.item.visitedPlace.id }
            }
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertEqual(expanded, [addedPlace!.visitedPlace.id])
    }
    
    func testSetNotExpaneded() throws {
        let testId = VisitedPlaceID()
        viewModel.set(
            AddedPlaceItem(
                visitedPlace: somePlace,
                pinColor: Trip.defaultPinColor
            ),
            expanded: false
        )
        
        let expanded = try viewModel.addedPlaces
            .map { $0.first?.items ?? [] }
            .map { items in items.filter { $0.expanded } }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertEqual(expanded, [])
    }
    
    
    // MARK: - Routing Tests
    func testMapTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.displayMapForTripCalled)
        let _ = viewModel.mapButton(.just(()))
        XCTAssertTrue(mockCoordinator.displayMapForTripCalled)
    }
    
    func testAddTappedCoordinatorIsNotified() {
        XCTAssertFalse(mockCoordinator.searchLocationForTripCalled)
        let _ = viewModel.addLocation(.just(()))
        XCTAssertTrue(mockCoordinator.searchLocationForTripCalled)
    }
    
}
