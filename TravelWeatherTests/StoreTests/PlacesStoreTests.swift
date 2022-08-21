//
//  PlacesStoreTests.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 21.08.22.
//

import Foundation
import XCTest
@testable import TravelWeather



class PlacesStoreTests: XCTestCase {
    
    var cdStack: CDStackType!
    var store: PlacesStoreType!
    
    
    override func setUpWithError() throws {
        super.setUpWithError()
        cdStack = TestableCDStack()
        store = PlacesStore(context: cdStack.storeContext, dispatch: cdStack.dispatch(_:))
    }
    
    
    func testExample() throws {
        // TODO!
    }
    
    
}
