//
//  TripsStoreTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import XCTest
import RxBlocking
@testable import TravelWeather



class TripsStoreTests: XCTestCase {
    
    var cdStack: CDStackType!
    var store: TripsStoreType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.cdStack = TestableCDStack()
        self.store = TripsStore(
            context: cdStack.storeContext,
            dispatch: cdStack.dispatch(_:)
        )
    }
    
    
    func testTripsIsEmptyInitially() throws {
        let trips = try store.trips(forSearch: "")
            .toBlocking()
            .first()
        
        XCTAssertNotNil(trips)
        XCTAssertEqual(trips?.count, 0)
    }
    
    func testAddTripProducesCorrectResult() throws {
        let mockedTrip = Trip(
            id: TripID(),
            title: "Mocked Trip",
            descr: "Mocked Description",
            members: "Mocked Members",
            visitedLocations: [],
            start: .now.addingTimeInterval(-86400),
            end: .now
        )
        
        let _ = try add(mockedTrip: mockedTrip)
    }
    
    func testAddTripTwiceIsOnlyUpdated() throws {
        let mockedTrip = Trip(
            id: TripID(),
            title: "Mocked Trip",
            descr: "Mocked Description",
            members: "Mocked Members",
            visitedLocations: [],
            start: .now.addingTimeInterval(-86400),
            end: .now
        )
        
        let addedTrip = try add(mockedTrip: mockedTrip)
        let updatedTrip = addedTrip.cloneBuilder()
            .with(title: "Different Mocked Title")
            .build()!
        let _ = store.update(.just(updatedTrip))
        
        let fetchedTrips = try store.trips(forSearch: "")
            .filter { $0.first?.title == updatedTrip.title }
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(fetchedTrips)
        XCTAssertEqual(fetchedTrips?.count, 1)
        XCTAssertEqual(fetchedTrips?.first?.id, updatedTrip.id)
    }
    
    func testDeleteTripProducesCorrectResult() throws {
        let mockedTrip = Trip(
            id: TripID(),
            title: "Mocked Trip",
            descr: "Mocked Description",
            members: "Mocked Members",
            visitedLocations: [],
            start: .now.addingTimeInterval(-86400),
            end: .now
        )
        
        let addedTrip = try add(mockedTrip: mockedTrip)
        
        let _ = store.delete(.just(addedTrip))
        let fetchedTrips = try store.trips(forSearch: addedTrip.title)
            .filter { $0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(fetchedTrips)
        XCTAssertEqual(fetchedTrips?.count, 0)
    }
    
    func testSearchProducesCorrectResult() throws {
        let trip1 = Trip(
            id: TripID(),
            title: "Mocked Title 1",
            visitedLocations: []
        )
        let trip2 = Trip(
            id: TripID(),
            title: "Mocked Title 2",
            visitedLocations: []
        )
        
        let _ = try add(mockedTrip: trip1)
        let _ = try add(mockedTrip: trip2)
        
        let searchedTrips1 = try store.trips(forSearch: trip1.title)
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(searchedTrips1)
        XCTAssertEqual(searchedTrips1?.count, 1)
        XCTAssertEqual(searchedTrips1?.first?.id, trip1.id)
        
        let searchedTrips2 = try store.trips(forSearch: trip2.title)
            .filter { !$0.isEmpty }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(searchedTrips2)
        XCTAssertEqual(searchedTrips2?.count, 1)
        XCTAssertEqual(searchedTrips2?.first?.id, trip2.id)
    }
    
    func testEmptySearchProducesAllResults() throws {
        let trip1 = Trip(
            id: TripID(),
            title: "Mocked Title 1",
            visitedLocations: []
        )
        let trip2 = Trip(
            id: TripID(),
            title: "Mocked Title 2",
            visitedLocations: []
        )
        
        let _ = try add(mockedTrip: trip1)
        let _ = try add(mockedTrip: trip2)
        
        let searchedTrips = try store.trips(forSearch: "")
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(searchedTrips)
        XCTAssertEqual(searchedTrips?.count, 2)
    }
    
    func testSameTripIdIsNotAddedTwice() throws {
        let trip1 = Trip(
            id: TripID(),
            title: "Mocked Trip 1",
            visitedLocations: []
        )
        let trip2 = trip1.cloneBuilder()
            .with(title: "Mocked Trip 2")
            .build()!
        
        let _ = try add(mockedTrip: trip1)
        let _ = try add(mockedTrip: trip2)
        
        let fetchedTrips = try store.trips(forSearch: "")
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(fetchedTrips)
        XCTAssertEqual(fetchedTrips?.count, 1)
        XCTAssertEqual(fetchedTrips?.first?.id, trip1.id)
        XCTAssertEqual(fetchedTrips?.first?.title, trip2.title)
    }
    
    func testFetchTripById() throws {
        let mockedTrip = Trip(id: TripID(), title: "Mocked Title", visitedLocations: [])
        let _ = try add(mockedTrip: mockedTrip)
        
        let fetchedTrip = try store.trip(identifiedBy: .just(mockedTrip.id))
            .toBlocking(timeout: 5)
            .first()!
        
        XCTAssertNotNil(fetchedTrip)
        XCTAssertEqual(fetchedTrip?.id, mockedTrip.id)
        XCTAssertEqual(fetchedTrip?.title, mockedTrip.title)
    }
    
    
    
    // MARK: - Helper
    func add(mockedTrip: Trip) throws -> Trip {
        let _ = store.update(.just(mockedTrip))
        let addedTrip = try store.trips(forSearch: mockedTrip.title)
            .compactMap { $0.first }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(addedTrip)
        XCTAssertEqual(mockedTrip.title, addedTrip?.title)
        XCTAssertEqual(mockedTrip.descr, addedTrip?.descr)
        XCTAssertEqual(mockedTrip.members, addedTrip?.members)
        XCTAssertEqual(mockedTrip.visitedLocations, addedTrip?.visitedLocations)
        
        return addedTrip!
    }
    
}
