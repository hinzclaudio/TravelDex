//
//  TravelDexScreenshots.swift
//  TravelDexScreenshots
//
//  Created by Claudio Hinz on 12.09.22.
//

import XCTest

class TravelDexScreenshots: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        self.app = XCUIApplication()
        setupSnapshot(app)
        self.app.launch()
        sleep(2)
    }


    func testSnapshotTripsList() {
        snapshot("trips_list")
    }
    
    func testSnapshotTripDetails() {
        app.staticTexts[Localizable.mockedTripTitle3].tap()
        sleep(2)
        snapshot("trip_detail")
    }
    
    func testSnapshotMap() {
        app.staticTexts[Localizable.mockedTripTitle3].tap()
        app.navigationBars.firstMatch.buttons["MapButton"].tap()
        sleep(10) // Some time for the map to load its data...
        snapshot("trip_map")
    }
    
}
