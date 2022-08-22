//
//  MockTripsStore.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxSwift
@testable import TravelWeather



class MockTripsStore: TripsStoreType {
    
    private(set) var addTripCalled = false
    func addTrip(_ trip: Observable<Trip>) -> Disposable {
        trip.subscribe(onNext: { [weak self] _ in self?.addTripCalled = true })
    }
    
    private(set) var deleteTripCalled = false
    func delete(_ trip: Observable<Trip>) -> Disposable {
        trip.subscribe(onNext: { [weak self] _ in self?.deleteTripCalled = true })
    }
    
    private(set) var tripsForSearchCalled = false
    func trips(forSearch query: String) -> Observable<[Trip]> {
        self.tripsForSearchCalled = true
        let mockedTrip = Trip(id: TripID(), title: "Mocked Trip", visitedLocations: [])
        return .just([mockedTrip])
    }
    
    private(set) var tripIdentifiedByCalled = false
    func trip(identifiedBy id: Observable<UUID>) -> Observable<Trip?> {
        let mockedTrip = id
            .map { id -> Trip? in Trip(id: id, title: "Mocked Trip", visitedLocations: []) }
        
        return id
            .do(onNext: { [weak self] _ in self?.tripIdentifiedByCalled = true })
            .withLatestFrom(mockedTrip)
    }
    
}
