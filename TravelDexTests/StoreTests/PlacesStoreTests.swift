//
//  PlacesStoreTests.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import XCTest
@testable import TravelDex



class PlacesStoreTests: XCTestCase {
    
    var trip: Trip!
    var locations: [Location]!
    
    var cdStack: CDStackType!
    var store: PlacesStoreType!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.cdStack = TestableCDStack()
        self.store = PlacesStore(context: cdStack.storeContext, dispatch: cdStack.dispatch(_:))
        self.trip = try self.prepareTrip()
        self.locations = try prepareLocations()
    }
    
    
    func testAllPlacesIsEmptyInitially() throws {
        let places = try store.allPlaces()
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(places)
        XCTAssertEqual(places?.count, 0)
    }
    
    func testPlacesForTripIsEmptyInitially() throws {
        let places = try store.places(for: .just(trip.id))
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(places)
        XCTAssertEqual(places?.count, 0)
    }
    
    func testAddLocationProducesCorrectResult() throws {
        let berlin = location(titled: "Berlin")
        store.add(berlin, to: trip)
        
        let addedPlace = try store.places(for: .just(trip.id))
            .compactMap { $0.first }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(addedPlace)
        XCTAssertEqual(addedPlace?.location.id, berlin.id)
        XCTAssertEqual(addedPlace?.location.coordinate, berlin.coordinate)
        XCTAssertEqual(addedPlace?.visitedPlace.tripId, trip.id)
    }
    
    func testAllPlacesIsUpdatedCorrectly() throws {
        try testAddLocationProducesCorrectResult()
        let addedPlaces = try store.allPlaces()
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(addedPlaces)
        XCTAssertEqual(addedPlaces?.count, 1)
    }
    
    func testFetchSpecificPlace() throws {
        let bremen = location(titled: "Bremen")
        store.add(bremen, to: trip)
        
        let addedPlace = try store.places(for: .just(trip.id))
            .compactMap { $0.first }
            .toBlocking(timeout: 5)
            .first()!
        
        let fetchedPlace = try store.place(identifiedBy: .just(addedPlace.visitedPlace.id))
            .compactMap { $0 }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertEqual(addedPlace, fetchedPlace)
    }
    
    func testUpadePlaceProducesCorrectResult() throws {
        let hamburg = location(titled: "Hamburg")
        store.add(hamburg, to: trip)
        
        let placesBeforeUpdate = try store
            .places(for: .just(trip.id))
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(placesBeforeUpdate)
        XCTAssertEqual(placesBeforeUpdate?.count, 1)
        XCTAssertEqual(placesBeforeUpdate?.first?.visitedPlace.text, nil)
        
        let newPlace = placesBeforeUpdate!.first!.visitedPlace
            .cloneBuilder()
            .with(text: "Mocked Text!")
            .build()!
        
        store.update(newPlace)
        
        let placesAfterUpdate = try store
            .places(for: .just(trip.id))
            .filter { $0.first?.visitedPlace.text == newPlace.text }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(placesAfterUpdate)
        XCTAssertEqual(placesAfterUpdate?.count, 1)
        XCTAssertEqual(placesAfterUpdate?.first?.visitedPlace.text, newPlace.text)
        XCTAssertEqual(placesAfterUpdate?.first?.visitedPlace.id, newPlace.id)
    }
    
    func testDeletePlaceProducesCorrectResult() throws {
        let hamburg = location(titled: "Hamburg")
        store.add(hamburg, to: trip)
        
        let placesBeforeUpdate = try store
            .places(for: .just(trip.id))
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(placesBeforeUpdate)
        XCTAssertEqual(placesBeforeUpdate?.count, 1)
        
        let newPlace = placesBeforeUpdate!.first!.visitedPlace
        store.delete(newPlace)
        
        let placesAfterUpdate = try store
            .places(for: .just(trip.id))
            .filter { $0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(placesAfterUpdate)
        XCTAssertEqual(placesAfterUpdate?.count, 0)
    }
    
    
   
    // MARK: - Helper
    func prepareTrip() throws -> Trip {
        let trip = Trip(
            id: TripID(),
            title: "Mocked Trip Title",
            visitedLocations: [],
            pinColorRed: Trip.defaultPinColorRed,
            pinColorGreen: Trip.defaultPinColorGreen,
            pinColorBlue: Trip.defaultPinColorBlue
        )
        
        let action = CDUpdateTrip(trip: trip)
        cdStack.dispatch(action)
        
        let query = CDTrip.fetchRequest()
        query.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)
        query.fetchLimit = 1
        
        let fetchedTrip = try CDObservable(fetchRequest: query, context: cdStack.storeContext)
            .compactMap { $0.first?.pureRepresentation }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(fetchedTrip)
        return fetchedTrip!
    }
    
    func prepareLocations() throws -> [Location] {
        let action = CDUpdateLocations(locations: MockLocationAPI.mockedLocations)
        cdStack.dispatch(action)
        
        let query = CDLocation.fetchRequest()
        let fetchedLocations =  try CDObservable(fetchRequest: query, context: cdStack.storeContext)
            .filter { $0.count == 3 }
            .compactMap { cdLocs in cdLocs.map { $0.pureRepresentation } }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(fetchedLocations)
        return fetchedLocations!
    }
    
    func location(titled t: String) -> Location {
        self.locations
            .first(where: { $0.name == t })!
    }
    
}
