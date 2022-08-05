//
//  DependencyProtocols.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



protocol AppDependencies:
    HasTripsStore
{}


// MARK: - Stores
protocol HasTripsStore {
    var tripsStore: TripsStoreType { get }
}
