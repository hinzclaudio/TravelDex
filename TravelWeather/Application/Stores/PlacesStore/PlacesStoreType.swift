//
//  PlacesStoreType.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift



protocol PlacesStoreType {
    
    func add(_ location: Location, to trip: Trip)
    func addedPlaces(for trip: Observable<UUID>) -> Observable<[AddedPlaceItem]>
    
}
