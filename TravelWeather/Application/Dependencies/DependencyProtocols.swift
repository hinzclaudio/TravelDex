//
//  DependencyProtocols.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



protocol AppDependencies:
    HasTripsStore &
    HasPlacesStore &
    HasLocationsStore
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
