//
//  DependencyProtocols.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



protocol AppDependencies:
    HasTripsStore &
    HasPlacesStore &
    HasLocationsStore &
    HasSKStore
{}


// MARK: - Stores
protocol HasTripsStore {
    var tripsStore: TripsStoreType { get }
}

protocol HasPlacesStore {
    var placesStore: PlacesStoreType { get }
}

protocol HasLocationsStore {
    var locationsStore: LocationsStoreType { get }
}

protocol HasSKStore {
    var skStore: SKStoreType { get }
}
