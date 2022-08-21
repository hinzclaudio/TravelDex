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
        // TODO: Write a protocol for CLGeocoder and mock it.
    }
    
}
