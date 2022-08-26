//
//  MockPlacesStore.swift
//  TravelWeatherTests
//
//  Created by Claudio Hinz on 22.08.22.
//

import Foundation
import RxSwift
@testable import TravelWeather



class MockPlacesStore: PlacesStoreType {
    
    static private let stableVisistedPlaceId = VisitedPlaceID()
    
    private(set) var addLocationToTripCalled = false
    func add(_ location: Location, to trip: Trip) {
        addLocationToTripCalled = true
    }
    
    private(set) var updateVisitedPlaceCalled = false
    func update(_ visitedPlace: VisitedPlace) {
        updateVisitedPlaceCalled = true
    }
    
    private(set) var deleteVisitedPlaceCalled = false
    func delete(_ visitedPlace: VisitedPlace) {
        deleteVisitedPlaceCalled = true
    }
    
    private(set) var allPlacesCalled = false
    func allPlaces() -> Observable<[AddedPlaceItem]> {
        .just([
            AddedPlaceItem(
                visitedPlace: VisitedPlace(
                    id: MockPlacesStore.stableVisistedPlaceId,
                    start: .now.addingTimeInterval(-86400),
                    end: .now,
                    tripId: TripID(),
                    locationId: MockLocationAPI.hamburg.id
                ),
                location: MockLocationAPI.hamburg
            )
        ])
        .do(onNext: { [weak self] _ in self?.allPlacesCalled = true })
    }
    
    private(set) var placesForTripCalled = false
    func places(for trip: Observable<TripID>) -> Observable<[AddedPlaceItem]> {
        trip
            .do(onNext: { [weak self] _ in self?.placesForTripCalled = true })
            .map { tripId in
                [
                    AddedPlaceItem(
                        visitedPlace: VisitedPlace(
                            id: MockPlacesStore.stableVisistedPlaceId,
                            start: .now.addingTimeInterval(-86400),
                            end: .now,
                            tripId: tripId,
                            locationId: MockLocationAPI.hamburg.id
                        ),
                        location: MockLocationAPI.hamburg
                    )
                ]
            }
    }
    
    private(set) var placeIdentifiedByCalled = false
    func place(identifiedBy id: Observable<VisitedPlaceID>) -> Observable<AddedPlaceItem?> {
        id
            .do(onNext: { [weak self] _ in self?.placeIdentifiedByCalled = true })
            .map { id in 
                AddedPlaceItem(
                    visitedPlace: VisitedPlace(
                        id: id,
                        start: .now.addingTimeInterval(-86400),
                        end: .now,
                        tripId: TripID(),
                        locationId: MockLocationAPI.hamburg.id
                    ),
                    location: MockLocationAPI.hamburg
                )
            }
    }
    
}
