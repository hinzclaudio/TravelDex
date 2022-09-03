//
//  MockDependencies.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
@testable import TravelDex



class MockDependencies: AppDependencies {
    
    let mockTripStore = MockTripsStore()
    let mockPlacesStore = MockPlacesStore()
    let mockLocationsStore = MockLocationsStore()
    
    var tripsStore: TripsStoreType { mockTripStore }
    var placesStore: PlacesStoreType { mockPlacesStore }
    var locationsStore: LocationsStoreType { mockLocationsStore }
    
}
