//
//  LocationsStoreTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import XCTest
import RxBlocking
import RxSwift
import RxRelay
@testable import TravelWeather



class LocationsStoreTests: XCTestCase {
    
    var cdStack: CDStackType!
    var store: LocationsStoreType!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.cdStack = TestableCDStack()
        let mockAPI = MockLocationAPI()
        self.store = LocationsStore(
            context: cdStack.storeContext,
            dispatch: cdStack.dispatch(_:),
            locationAPI: mockAPI
        )
    }
    
    
    func testAllLocationsIsEmptyInitially() throws {
        let locs = try store.allLocations()
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(locs)
        XCTAssertEqual(locs?.count, 0)
    }
    
    func testAddLocationProducesCorrectResult() throws {
        let berlin = MockLocationAPI.berlin
        let _ = store.add(.just(berlin))
        let fetchedLocation = try store
            .allLocations()
            .compactMap { $0.first }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(fetchedLocation)
        XCTAssertEqual(fetchedLocation, berlin)
    }
    
    func testLocationsWithEmptyQueryReturnsAllLocations() throws {
        let _ = store.add(.of(MockLocationAPI.berlin, MockLocationAPI.bremen))
        let fetchedLocations = try store
            .locations(for: .just(""))
            .filter { $0.count == 2 }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNotNil(fetchedLocations)
        XCTAssertEqual(fetchedLocations, [MockLocationAPI.berlin, MockLocationAPI.bremen])
    }
    
    func testSearchForLocationProducesAPIResult() throws {
        let fetchedLocations = try store
            .locations(for: .just("Hamburg"))
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(fetchedLocations)
        XCTAssertEqual(fetchedLocations, [MockLocationAPI.hamburg])
    }
    
    func testSearchForCoordinateProducesAPIResult() throws {
        let fetchedLocation = try store
            .location(for: .just(MockLocationAPI.hamburg.coordinate))
            .toBlocking(timeout: 5)
            .first()
        XCTAssertNotNil(fetchedLocation)
        XCTAssertEqual(fetchedLocation, MockLocationAPI.hamburg)
    }
    
    func testSearchWithErrorIsPublished() throws {
        self.store = LocationsStore(
            context: cdStack.storeContext,
            dispatch: cdStack.dispatch(_:),
            locationAPI: MockLocationErrorAPI()
        )
        
        let bag = DisposeBag()
        
        let recordedErrors = BehaviorRelay<Error?>(value: nil)
        store.error.bind(to: recordedErrors)
            .disposed(by: bag)
        
        let locations = try store.locations(for: .just("TEST"))
            .toBlocking(timeout: 5)
            .first()
        
        let publishedError = try recordedErrors
            .compactMap { $0 }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNil(locations)
        XCTAssertNotNil(publishedError)
    }
    
    func testReverseGeocodeErrorIsPublished() throws {
        self.store = LocationsStore(
            context: cdStack.storeContext,
            dispatch: cdStack.dispatch(_:),
            locationAPI: MockLocationErrorAPI()
        )
        
        let bag = DisposeBag()
        
        let recordedErrors = BehaviorRelay<Error?>(value: nil)
        store.error.bind(to: recordedErrors)
            .disposed(by: bag)
        
        let location = try store.location(for: .just(MockLocationAPI.hamburg.coordinate))
            .toBlocking(timeout: 5)
            .first()
        
        let publishedError = try recordedErrors
            .compactMap { $0 }
            .toBlocking(timeout: 5)
            .first()
        
        XCTAssertNil(location)
        XCTAssertNotNil(publishedError)
    }
    
}
