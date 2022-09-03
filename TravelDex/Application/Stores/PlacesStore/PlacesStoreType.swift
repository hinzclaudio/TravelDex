//
//  PlacesStoreType.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift



protocol PlacesStoreType {
    
    func add(_ location: Location, to trip: Trip)
    func update(_ visitedPlace: VisitedPlace)
    func delete(_ visitedPlace: VisitedPlace)
    
    func allPlaces() -> Observable<[AddedPlaceItem]>
    func places(for trip: Observable<TripID>) -> Observable<[AddedPlaceItem]>
    func place(identifiedBy id: Observable<VisitedPlaceID>) -> Observable<AddedPlaceItem?>
    
}
