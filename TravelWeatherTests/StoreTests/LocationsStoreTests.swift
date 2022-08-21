//
//  LocationsStoreTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import XCTest
import RxBlocking
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
    
    
    func testExample() throws {
        // TODO: Implement.
    }
    
    
//    [ ] var error: Observable<Error> { get }
//    [ ] func add(_ location: Observable<Location>) -> Disposable
//    [ ] func allLocations() -> Observable<[Location]>
//    [ ] func locations(for query: Observable<String>, bag: DisposeBag) -> Observable<[Location]>
}
