//
//  MockTripsStore.swift
//  TravelDexTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxSwift
@testable import TravelDex



class MockTripsStore: TripsStoreType {
    
    private(set) var exportTripCalled = false
    func export(_ trip: TravelDex.Trip) -> Observable<URL> {
        exportTripCalled = true
        return .empty()
    }
    
    private(set) var importDataCalled = false
    func importData(from fileURL: URL, inPlace: Bool) -> Observable<Trip> {
        importDataCalled = true
        return .just(
            Trip(
                id: TripID(),
                title: "Mock Title",
                visitedLocations: [],
                pinColorRed: Trip.defaultPinColorRed,
                pinColorGreen: Trip.defaultPinColorGreen,
                pinColorBlue: Trip.defaultPinColorGreen
            )
        )
    }
    
    private(set) var updateTripCalled = false
    func update(_ trip: Observable<Trip>) -> Disposable {
        trip.subscribe(onNext: { [weak self] _ in self?.updateTripCalled = true })
    }
    
    private(set) var deleteTripCalled = false
    func delete(_ trip: Observable<Trip>) -> Disposable {
        trip.subscribe(onNext: { [weak self] _ in self?.deleteTripCalled = true })
    }
    
    private(set) var tripsForSearchCalled = false
    func trips(forSearch query: String) -> Observable<[Trip]> {
        self.tripsForSearchCalled = true
        let mockedTrip = Trip(
            id: TripID(),
            title: "Mocked Trip",
            visitedLocations: [],
            pinColorRed: Trip.defaultPinColorRed,
            pinColorGreen: Trip.defaultPinColorGreen,
            pinColorBlue: Trip.defaultPinColorBlue
        )
        return .just([mockedTrip])
    }
    
    private(set) var tripIdentifiedByCalled = false
    func trip(identifiedBy id: Observable<UUID>) -> Observable<Trip?> {
        let mockedTrip = id
            .map { id -> Trip? in
                Trip(
                    id: id,
                    title: "Mocked Trip",
                    visitedLocations: [],
                    pinColorRed: Trip.defaultPinColorRed,
                    pinColorGreen: Trip.defaultPinColorGreen,
                    pinColorBlue: Trip.defaultPinColorBlue
                )
            }
        
        return id
            .do(onNext: { [weak self] _ in self?.tripIdentifiedByCalled = true })
            .withLatestFrom(mockedTrip)
    }
    
}
